class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: 'notifications@groceryguru.io'
  layout 'mailer'
end
