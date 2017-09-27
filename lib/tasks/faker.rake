require 'faker'

namespace :faker do
  desc "Generates fake submissions"
  task :submissions, [:count] => :environment do |t, args|
    count = args[:count].to_i
    progress_bar = RakeProgressbar.new(count)

    count.times do
      Submission.create! model_type: :store, value: Faker::Address.street_address, user: User.first
      Submission.create! model_type: :item, value: Faker::Food.dish, user: User.first
      Submission.create! model_type: :mode, value: Faker::Food.spice, user: User.first
      progress_bar.inc
    end

    progress_bar.finished
  end

  desc "Generates fake receipts"
  task :receipts, [:count] => :environment do |t, args|
    count = args[:count].to_i
    progress_bar = RakeProgressbar.new(count)
    puts "Creating receipts"

    count.times do |i|
      receipt = Receipt.create! user: User.first,
                                store: Store.find(Store.all.ids.sample),
                                line_count: 30,
                                processed: true,
                                date: Faker::Date.backward(300)

      15.times do
        food_name = Faker::Food.ingredient
        price = Faker::Commerce.price
        weight_fakers = [
          Faker::Measurement.metric_weight,
          Faker::Measurement.weight,
          Faker::Measurement.volume,
          Faker::Measurement.metric_volume
        ]

        Transaction.create! user: User.first,
                            receipt: receipt,
                            item: Item.fuzzy_search(food_name).records.first,
                            price: price,
                            raw: "#{food_name} - #{price}",
                            weight: weight_fakers.sample
      end

      15.times do
        food_name = Faker::Food.ingredient
        price = Faker::Commerce.price

        Transaction.create! user: User.first,
                            receipt: receipt,
                            item: Item.fuzzy_search(food_name).records.first,
                            price: price,
                            raw: "#{food_name} - #{price}",
                            count: rand(10)
      end
      progress_bar.inc
    end

    progress_bar.finished
    puts "Receipts generated"
  end
end