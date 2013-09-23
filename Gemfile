source 'https://rubygems.org'

gem 'parslet'
gem 'guard'


# Middleman Gemfile contents for generating docs
gem "middleman", "~>3.1.5"

# Live-reloading plugin
gem "middleman-livereload", "~> 3.1.0"

gem "middleman-gh-pages", :git => 'https://github.com/baroquebobcat/middleman-gh-pages.git',
                          :require => false

# For faster file watcher updates on Windows:
gem "wdm", "~> 0.1.0", :platforms => [:mswin, :mingw]

# Cross-templating language block fix for Ruby 1.8
platforms :mri_18 do
  gem "ruby18_source_location"
end