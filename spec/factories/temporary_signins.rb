FactoryGirl.define do
  factory :temporary_signin do
    factory :email_address_confirmation

    association :email_address
    user { email_address.user }
  end
end
