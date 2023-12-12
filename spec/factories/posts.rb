FactoryBot.define do
  factory :post do
    title { Faker::Lorem.paragraph_by_chars(number: rand(3..30)) }
    text { Faker::Lorem.paragraph_by_chars(number: rand(10..600)) }
    association :user, factory: :user
  end
end
