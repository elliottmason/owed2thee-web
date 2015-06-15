FactoryGirl.define do
  factory :user do
    password { SecureRandom.hex(8) }

    factory :confirmed_user,  traits: [:confirmed, :with_email]
    factory :user_with_email, traits: [:with_email]

    trait :confirmed do
      after(:create) do |user, _|
        email = user.emails.first
        ConfirmUserEmail.with(email.email, email.confirmation_token)
      end
    end

    trait :with_email do
      after(:build) do |user, _|
        user.emails << build(:user_email, user: user)
      end
    end
  end
end
