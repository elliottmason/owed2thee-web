FactoryGirl.define do
  factory :user do
    factory :confirmed_user, traits: [:confirmed, :with_name]
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
      password { SecureRandom.hex(8) }

      after(:create) do |user, _|
        email_address = user.email_addresses.first
        ConfirmEmailAddress.with(email_address.address,
                                 email_address.confirmation_token)
      end
    end

    trait :with_name do
      first_name  { Faker::Name.first_name }
      last_name   { Faker::Name.last_name }
    end
  end
end
