FactoryGirl.define do
  factory :user, traits: [:with_email] do
    factory :confirmed_user,  traits: [:confirmed]
    factory :unconfirmed_user
    factory :user_with_email

    trait :confirmed do
      password { SecureRandom.hex(8) }

      after(:create) do |user, _|
        email_address = user.email_addresses.first
        ConfirmEmailAddress.with(email_address.address,
                                 email_address.confirmation_token)
      end
    end

    trait :with_email do
      after(:build) do |user, _|
        user.email_addresses << build(:email_address, user: user)
      end
    end
  end
end
