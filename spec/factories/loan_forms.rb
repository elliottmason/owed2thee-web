FactoryGirl.define do
  factory :loan_form do
    amount { Random.new.rand((0.1)..(1000).round(2)) }
    creator_email_address { Faker::Internet.email }
    obligor_email_address { Faker::Internet.email }
  end
end
