FactoryGirl.define do
  factory :loan_form do
    amount { Faker::Commerce.price }
    creator_email_address { Faker::Internet.email }
    obligor_email_address { Faker::Internet.email }
  end
end
