FactoryBot.define do
  factory :audit_log do
    association :account
    association :actor, factory: :user

    transient do
      target { account }
    end

    target_type { target.class.name }
    target_id   { target.id }

    action { "account.updated" }
    metadata { {} }

    after(:build) do |audit_log, evaluator|
      audit_log.target_id ||= evaluator.target.id
    end
  end
end

# factory :audit_log do
#   association :account, strategy: :create
#   association :actor, factory: :user, strategy: :create

#   target_type { "Account" }
#   target_id   { account.id }

#   action { "account.updated" }
#   metadata { {} }
# end



# FactoryBot.define do
#   factory :audit_log do
#     association :account
#     association :actor, factory: :user

#     target_type { "Account" }
#     target_id   { account.id }

#     action { "account.updated" }
#     metadata { {} }
#   end
# end
