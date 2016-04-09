FactoryGirl.define do
  factory :temporary_signin do
    association :email_address
    user { email_address.user }
  end
end
