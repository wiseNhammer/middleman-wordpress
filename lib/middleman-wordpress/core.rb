module MiddlemanWordPress
  class << self
    attr_reader :options
  end

  class Core < Middleman::Extension
    option :uri, nil, "The WordPress API uri"
    option :custom_post_types, [], "Custom post types"

    def initialize(app, options_hash={}, &block)
      super

      MiddlemanWordPress.instance_variable_set('@options', options)
    end

    helpers do
      Dir["data/wordpress_*"].each do |file|
        define_method(file.gsub("data/wordpress_", "")) do
          file = File.read(file)
          return JSON.parse(file)
        end
      end
    end
  end
end
