# middleman-wordpress

An extension for Middleman that pulls content from WordPress.

## About

This extension pulls content from WordPress via the WP REST API plugin for WordPress.

## Installation

```
gem install middleman-wordpress
```

## Configuration

in `config.rb`

```ruby
activate :wordpress do |wp|
  wp.uri = 'example.com'
  wp.custom_post_types = [:events, :resources, :other_things]
end
```

## Import Data

To import data, run:

```
middleman wordpress
```

## License

Copyright (c) 2015 Wise & Hammer. Middleman-WordPress is free software and
may be redistributed under the terms specified in the [license](LICENSE.md).
