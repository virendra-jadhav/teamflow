FactoryBot.define do
  factory :invitation do
    account { nil }
    email { "MyString" }
    role { "MyString" }
    token { "MyString" }
    invited_by { nil }
    expires_at { "2026-01-14 23:00:03" }
    accepted_at { "2026-01-14 23:00:03" }
  end
end
