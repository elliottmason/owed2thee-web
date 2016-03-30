require 'rails_helper'

feature 'Cancelling a loan', :js do
  let(:cancellation_notice) do
    'You canceled your loan to eleo@gmail.com for $10.00'
  end
  let(:loan) do
    recipient = FactoryGirl.create(
      :confirmed_user,
      email_address: 'eleo@gmail.com'
    )
    FactoryGirl.create(:unpublished_loan, amount: 10.00, recipient: recipient)
  end

  let(:show_loan_page) { Loans::ShowPage.new }

  context 'as the creator' do
    before do
      login_as(loan.creator)
      show_loan_page.load(uuid: loan.uuid)
      show_loan_page.cancel
    end

    scenario 'displays confirmation of loan cancellation' do
      expect(show_loan_page).to have_content(cancellation_notice)
      expect(show_loan_page).to be_displayed
      expect(show_loan_page).to_not have_cancel_button
    end
  end
end
