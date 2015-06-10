# Require core library
require 'middleman-core'

require 'middleman-wordpress/version'
require 'middleman-wordpress/core'
require 'middleman-wordpress/commands/wordpress'

::Middleman::Extensions.register(:wordpress, MiddlemanWordPress::Core)
