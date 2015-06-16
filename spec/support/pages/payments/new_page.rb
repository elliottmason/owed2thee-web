module Payments
  class NewPage < SitePrism::Page
    include FormSection

    set_url '/loans{/uuid}/payments/new'

    element :amount_dollars_field,  '#payment_amount_dollars'
    element :amount_cents_field,    '#payment_amount_cents'
  end
end
