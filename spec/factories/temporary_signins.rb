FactoryGirl.define do
  factory :temporary_signin do
    email_address { create(:email_address) }
    user { email_address.user }
    expires_at { 1.hour.from_now }

    factory :email_address_confirmation,  class: 'EmailAddressConfirmation'
    factory :password_reset,              class: 'PasswordReset'

    trait :expired do
      expires_at { 1.minute.ago }
    end
  end
end
