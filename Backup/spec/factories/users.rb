FactoryBot.define do
  factory :user do
    name  { "Test User" }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
    # role { "member" }
    confirmed_at  { Time.current }

    # trait :admin do
    #   role { "admin" }
    # end
  end
end
