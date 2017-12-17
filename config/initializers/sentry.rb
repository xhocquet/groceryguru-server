if Rails.env.production?
  Raven.configure do |config|
    config.dsn = 'https://3b87f42ab5d0475ab876dd4e72823e13:9f367fea6fdc46d7a96319dae51e5e75@sentry.io/260444'
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end