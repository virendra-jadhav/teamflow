FactoryBot.define do
  factory :user do
    name  { "Test User" }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
    role { "member" }

    trait :admin do
      role { "admin" }
    end
  end
end
