require 'support/pages/form_section'

module Loans
  class NewPage < SitePrism::Page
    include FormSection

    set_url '/loans/new'

    form_section :loan,
                 fields:    %i(amount creator_email_address \
                               obligor_email_address type),
                 selector:  '#new_loan'
  end
end
