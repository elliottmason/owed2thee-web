module Loans
  class ShowPage < SitePrism::Page
    set_url '/loans{/uuid}'
    set_url_matcher %r{loans/[a-z\d]+}

    element :cancel_button,   'form.cancel_button input[type="submit"]'
    element :confirm_button,  'form.confirm_button input[type="submit"]'
    element :dispute_button,  'form.dispute_button input[type="submit"]'
    element :payment_button,  'form.pay_button input[type="submit"]'

    def cancel
      cancel_button.click
    end

    def confirm
      confirm_button.click
    end

    def dispute
      dispute_button.click
    end
  end
end
