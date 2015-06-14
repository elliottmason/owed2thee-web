module Loans
  class NewPage < SitePrism::Page
    include FormSection

    set_url '/loans/new'

    element :creator_email_field,   '#loan_creator_email'
    element :type_field,            '#loan_type'
    element :amount_dollars_field,  '#loan_amount_dollars'
    element :amount_cents_field,    '#loan_amount_cents'
    element :obligor_email_field,   '#loan_obligor_email'
  end
end
