require 'support/pages/form_section'

module LoanRequests
  class NewPage < SitePrism::Page
    include FormSection

    set_url '/loan_requests/new'

    form_section :loan_request,
                 fields:    %i(amount_requested disbursement_deadline \
                               repayment_deadline),
                 selector:  '#new_loan_request'
  end
end
