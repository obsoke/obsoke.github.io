source "https://rubygems.org"

# If you have any plugins, put them here!
# group :jekyll_plugins do
#   gem "jekyll-github-metadata", "~> 1.0"
# end
require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'github-pages', versions['github-pages']
