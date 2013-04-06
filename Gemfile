source 'https://rubygems.org'

gem 'thin'
gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib'
gem 'rake'

# Mithril
path '../truesilver' do
  gem 'mithril',      '~> 0.4.3'
  gem 'mithril-spec', '~> 0.4.3'
end # path

path '../rspec-sleeping_king_studios' do
  gem 'rspec-sleeping_king_studios'
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
  gem 'rspec', '~> 2.13.0'
  gem 'factory_girl'
  gem 'database_cleaner'
end # group test
