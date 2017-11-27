source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'
gem 'pg', :group => :production
gem 'puma', '~> 3.7'

gem 'bulk_insert' # bulk inserts

gem 'sass-rails', '~> 5.0'
gem 'roadie' # Styles for emails
gem 'roadie-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'kaminari'

gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 3.0'
gem 'bcrypt', '~> 3.1.11'

gem 'devise'
gem 'simple_token_authentication'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'recaptcha', require: 'recaptcha/rails'

gem 'active_link_to'

gem 'rmagick'
gem 'rtesseract' #OCR

gem 'carrierwave' # attachments

gem 'ruby-units' # measurements and weights
gem 'money-rails' # money
gem 'chronic'

gem 'elasticsearch-model'
gem 'elasticsearch-rails'

group :test do
  gem 'simplecov'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
  gem 'sqlite3'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'rake-progressbar'
  gem 'letter_opener'
end

group :production do
  gem 'newrelic_rpm'
  gem 'bonsai-elasticsearch-rails'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby "2.4.1"
