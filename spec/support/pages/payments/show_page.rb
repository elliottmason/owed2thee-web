module Payments
  class ShowPage < SitePrism::Page
    set_url '/payments{/uuid}'
    set_url_matcher %r{payments/[a-z\d]+}

    element :confirm_button,  'input[value="Confirm"]'

    def confirm
      confirm_button.click
    end
  end
end
