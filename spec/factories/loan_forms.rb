FactoryGirl.define do
  factory :loan_form do
    amount { Random.new.rand((0.1)..(1000).round(2)) }
    creator_email { Faker::Internet.email }
    obligor_email { Faker::Internet.email }
  end
end
