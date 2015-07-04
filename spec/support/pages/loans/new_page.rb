module Loans
  class NewPage < SitePrism::Page
    include FormSection

    set_url '/loans/new'

    element :creator_email_address_field, '#loan_creator_email_address'
    element :type_field,                  '#loan_type'
    element :amount_field,                '#loan_amount'
    element :obligor_email_address_field, '#loan_obligor_email_address'
  end
end
