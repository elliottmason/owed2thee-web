FactoryGirl.define do
  factory :user do
    factory :confirmed_user, traits: [:confirmed]
    factory :unconfirmed_user
    factory :user_with_email

    transient do
      email_address nil
    end

    after(:build) do |user, evaluator|
      email_address = build(:email_address, user: user)
      email_address.address = evaluator.email_address if evaluator.email_address
      user.email_addresses << email_address
    end

    trait :confirmed do
      password 'password'

      after(:create) do |user, _|
        ConfirmEmailAddress.with(user.email_addresses.first)
      end
    end
  end
end
