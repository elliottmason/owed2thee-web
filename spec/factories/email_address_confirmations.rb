FactoryGirl.define do
  factory :email_address_confirmation,  class: 'EmailAddressConfirmation',
                                        parent: :temporary_signin
end
