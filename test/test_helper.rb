require 'simplecov'
SimpleCov.start 'rails'
puts "="*10
puts "Starting test coverage report"
puts "="*10
puts "\n"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
