require 'support/pages/form_section'

module Payments
  class NewPage < SitePrism::Page
    include FormSection

    set_url '/users{/user_uuid}/payments/new'

    form_section :payment,
                 fields:    %i(amount),
                 selector:  '#new_payment'
  end
end
