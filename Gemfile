source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'
gem 'sqlite3'
gem 'pg', :group => :production
gem 'puma', '~> 3.7'

gem 'sass-rails', '~> 5.0'
gem 'roadie' # Styles for emails
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'

gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 3.0'
gem 'bcrypt', '~> 3.1.11'

gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem "recaptcha", require: "recaptcha/rails"

gem 'active_link_to'

gem 'rmagick'
gem 'rtesseract' #OCR

gem 'carrierwave' # attachments

gem 'ruby-units' # measurements and weights
gem 'money-rails' # money
gem 'chronic'

gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'figaro'

group :test do
  gem 'simplecov'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'rake-progressbar'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
