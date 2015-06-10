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

        # Grab all the posts
        api   = WP::API[MiddlemanWordPress.options.uri]

        # Grab all the pages
        posts = api.posts.concat api.pages

        # Grab posts of custom types
        MiddlemanWordPress.options.custom_post_types.each do |post_type|
          posts.concat api.posts(type: post_type.to_s.singularize)
        end

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
    end
  end
end
