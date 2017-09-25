require 'faker'

namespace :faker do
  desc "Generates fake submissions"
  task :submissions, [:count] => :environment do |t, args|
    count = args[:count].to_i

    puts "Creating fake store submissions (#{count})"
    count.times do
      Submission.create! model_type: :store, value: Faker::Address.street_address, user: User.first
    end

    puts "Creating fake item submissions (#{count})"
    count.times do
      Submission.create! model_type: :item, value: Faker::Food.dish, user: User.first
    end

    puts "Creating fake storee submissions (#{count})"
    count.times do
      Submission.create! model_type: :mode, value: Faker::Food.spice, user: User.first
    end
  end

  desc "Generates fake receipts"
  task :receipts, [:count] => :environment do |t, args|
    count.times do
      # TODO
    end
  end
end