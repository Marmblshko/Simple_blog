FactoryBot.define do
  factory :comment do
    author { Faker::Name.name }
    body { Faker::Lorem.paragraph_by_chars(number: rand(5..150))  }
    association :post, factory: :post
  end
end
