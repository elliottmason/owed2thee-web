module Loans
  class ShowPage < SitePrism::Page
    set_url '/loans{/id}'
    set_url_matcher %r{loans/\d+}

    element :cancel_button,   'input[value="Cancel"]'
    element :confirm_button,  'input[value="Confirm"]'
    element :dispute_button,  'input[value="Dispute"]'

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
