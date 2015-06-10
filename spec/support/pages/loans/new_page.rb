module Loans
  class NewPage < SitePrism::Page
    set_url '/loans/new'

    element :creator_email_field,   '#loan_creator_email'
    element :type_field,            '#loan_type'
    element :amount_dollars_field,  '#loan_amount_dollars'
    element :amount_cents_field,    '#loan_amount_cents'
    element :obligor_email_field,   '#loan_obligor_email'
    element :submit_button,         'input[type="submit"]'

    def submit(params = {})
      params.each do |key, value|
        send(:"#{key}_field").set(value)
      end
      submit_button.click
    end
  end
end
