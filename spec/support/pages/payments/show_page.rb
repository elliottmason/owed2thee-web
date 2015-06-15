module Payments
  class ShowPage < SitePrism::Page
    set_url '/payments{/id}'
    set_url_matcher %r{payments/\d+}

    element :confirm_button,  'input[value="Confirm"]'

    def confirm
      confirm_button.click
    end
  end
end
