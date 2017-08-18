source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'

gem 'sqlite3'

gem 'puma', '~> 3.7'

gem 'sass-rails', '~> 5.0'
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

gem 'active_link_to'

gem 'rmagick'
gem 'rtesseract' #OCR

gem 'carrierwave' # attachments

gem 'ruby-units' # measurements and weights
gem 'money-rails' # money
gem 'openfoodfacts' #FOOOOOD

# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
  gem 'faster_require' # caching for significant windows speed increase
  # gem 'capybara', '~> 2.13'
  # gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
