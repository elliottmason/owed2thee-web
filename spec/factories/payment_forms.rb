FactoryGirl.define do
  factory :payment_form do
    amount { Random.new.rand((0.1)..(1000).round(2)) }
  end
end
