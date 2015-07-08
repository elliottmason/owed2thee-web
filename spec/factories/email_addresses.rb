FactoryGirl.define do
  factory :email_address do
    factory :unconfirmed_email_address

    address { Faker::Internet.email }
  end
end
