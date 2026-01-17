FactoryBot.define do
  factory :invitation do
    account
    invited_by { association :user }
    email { Faker::Internet.unique.email }
    role { "member" }
    token { SecureRandom.urlsafe_base64 }
    expires_at { 7.days.from_now }
    # accepted_at {}
  end
end
