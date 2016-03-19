FactoryGirl.define do
  factory :payment, aliases: %i(unpublished_payment) do
    association :creator, factory: :confirmed_user
    association :payee,   factory: :confirmed_user
    payer { creator }
    amount_cents 100

    factory :confirmed_payment, traits: %i(published confirmed)
    factory :published_payment, aliases:  %i(unconfirmed_payment),
                                traits:   %i(published)

    trait :confirmed do
      after(:create) do |payment, _|
        ConfirmPayment.with(payment, payment.creator)
      end
    end

    trait :published do
      after(:create) do |payment, _|
        PublishPayment.with(payment, payment.creator)
      end
    end
  end
end
