class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: "\"GroceryGuru Notifications\" <notifications@groceryguru.io>"
  layout 'mailer'
end
