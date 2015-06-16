module Loans
  class ShowPage < SitePrism::Page
    set_url '/loans{/uuid}'
    set_url_matcher %r{loans/[a-z\d]+}

    element :cancel_button,   'input[value="Cancel"]'
    element :confirm_button,  'input[value="Confirm"]'
    element :dispute_button,  'input[value="Dispute"]'
    element :payment_button,  'input[value="Submit Payment"]'

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
