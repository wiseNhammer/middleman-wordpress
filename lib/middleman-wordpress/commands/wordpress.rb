require 'json'
require 'fileutils'
require 'middleman-core/cli'
require 'wp/api'

module Middleman
  module Cli
    class WordPress < Thor
      include Thor::Actions

      # Path where Middleman expects the local data to be stored
      MIDDLEMAN_LOCAL_DATA_FOLDER = 'data'

      check_unknown_options!

      namespace :wordpress
      desc 'wordpress', 'Import data from WordPress'

      # @todo option to rebuild site if data changes
      # method_option "rebuild", aliases: "-r", desc: "Rebuilds the site if there were changes to the imported data"

      def self.source_root
        ENV['MM_ROOT']
      end

      # Tell Thor to exit with a nonzero exit code on failure
      def self.exit_on_failure?
        true
      end

      def wordpress
        ::Middleman::Application.server.inst

        # Create data directory if it does not exist
        Dir.mkdir('data') unless File.exists?('data')

        # Remove all WordPress files
        FileUtils.rm_rf(Dir.glob('data/wordpress_*'))

        # Instantiate the client
        @api = WP::API[MiddlemanWordPress.options.uri]

        # Build-up posts
        posts = []
        posts.concat fetch_pages_collection
        posts.concat fetch_posts_collection(:posts)

        MiddlemanWordPress.options.custom_post_types.each do |post_type|
          posts.concat fetch_posts_collection(post_type)
        end

        # Strip out headers; keep attributes
        posts.map!{|post| post.attributes}

        # Derive all the post types
        post_types = []
        posts.each{|post| post_types << post['type']}
        post_types.uniq!

        # Save the posts out to disc in collections by post type
        post_types.each do |post_type|
          collection_name = post_type.pluralize
          collection      = posts.select{|post| post['type'] == post_type}
          extension       = "json"

          File.open("data/wordpress_#{collection_name}.#{extension}", "w") do |f|
            f.write(collection.to_json)
          end
        end
      end

      protected

        def fetch_pages_collection
          pages = []
          page  = 1
          limit = 10

          tmp_pages = fetch_pages(page, limit)
          while !tmp_pages.empty?
            pages.concat tmp_pages
            page = page + 1
            tmp_pages = fetch_pages(page, limit)
          end

          pages
        end

        def fetch_posts_collection(type)
          type  = type.to_s.singularize
          posts = []
          page  = 1
          limit = 10

          tmp_posts = fetch_posts(type, page, limit)
          while !tmp_posts.empty?
            posts.concat tmp_posts
            page = page + 1
            tmp_posts = fetch_posts(type, page, limit)
          end

          posts
        end

        def fetch_pages(page, limit)
          begin
            pages = @api.pages(page: page, posts_per_page: limit)
          rescue WP::API::ResourceNotFoundError => e
            # Who cares? We've reached the end of the list
            pages = []
          end

          pages
        end

        def fetch_posts(type, page, limit)
          begin
            posts = @api.posts(type: type, page: page, posts_per_page: limit)
          rescue WP::API::ResourceNotFoundError => e
            # Who cares? We've reached the end of the list
            posts = []
          end

          posts
        end
    end
  end
end
