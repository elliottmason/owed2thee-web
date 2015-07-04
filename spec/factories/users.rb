FactoryGirl.define do
  factory :user do
    password { SecureRandom.hex(8) }

    factory :confirmed_user,  traits: [:confirmed, :with_email]
    factory :user_with_email, traits: [:with_email]

    trait :confirmed do
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
