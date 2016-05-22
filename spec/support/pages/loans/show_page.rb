module Loans
  class ShowPage < SitePrism::Page
    include FormSection

    set_url '/loans{/uuid}'
    set_url_matcher %r{loans/[a-z\d\-]+$}

    element :cancel_button,   :button, 'cancel'
    element :confirm_button,  :button, 'confirm'
    element :dispute_button,  :button, 'dispute'
    element :payment_button,  :button, 'make payment'

    form_section :description,
                 fields:        %i(body),
                 field_prefix:  'loan_description',
                 selector:      '.description-form'

    def cancel
      cancel_button.click
    end

    def confirm
      confirm_button.click
    end

    def dispute
      dispute_button.click
    end

    def submit_description(text)
      description_form.submit(body: text)
    end
  end
end
