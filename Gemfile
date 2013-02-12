source 'https://rubygems.org'

gem 'thin'
gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib'
gem 'rake'

# Mithril
path '../truesilver' do
  gem 'mithril', '~> 0.3.0'
  gem 'mithril-specs', :group => :test
end # path

# Assets
gem 'json'
gem 'haml'
gem 'sass'
gem 'coffee-script'

# Data Mapping
gem 'mongoid'
gem 'bson_ext'
gem 'bcrypt-ruby', '~> 3.0.0'

# Testing
group :test do
  gem 'rspec-core', :git => 'git://github.com/rspec/rspec-core.git'
  gem 'rspec'
  gem 'factory_girl'
  gem 'database_cleaner'
end # group test
