FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "#{n}_#{Faker::Internet.username(specifier: 3..22)}" }
    email { Faker::Internet.email }
    password { 123_123 }
    password_confirmation { 123_123 }
  end
end