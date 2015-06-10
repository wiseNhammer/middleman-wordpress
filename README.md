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
