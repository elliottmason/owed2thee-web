module Loans
  module Payments
    class NewPage < ::Payments::NewPage
      set_url '/loans{/loan_uuid}/payments/new'
    end
  end
end
