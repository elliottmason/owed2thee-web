FactoryGirl.define do
  factory :payment_form do
    amount    { Faker::Commerce.price }
  end
end
