require 'rails_helper'

feature 'Submitting a payment to a lender', :js do
  let(:new_payment_page)  { Loans::Payments::NewPage.new }
  let(:show_loan_page)    { Loans::ShowPage.new }
  let(:show_payment_page) { Payments::ShowPage.new }

  let(:loan) { FactoryGirl.create(:confirmed_loan) }

  context 'as a borrower' do
    before do
      login_as(loan.borrower)
      show_loan_page.load(uuid: loan.uuid)
      show_loan_page.payment_button.click
      new_payment_page.payment_form.submit(
        FactoryGirl.attributes_for(:payment_form))
    end

    scenario do
      expect(show_payment_page).to be_displayed
    end
  end

  context 'as the lender' do
    before do
      login_as(loan.lender)
      show_loan_page.load(uuid: loan.uuid)
    end

    scenario do
      expect(show_loan_page).to_not have_payment_button
    end
  end

  context 'invalid params' do
    before do
      login_as(loan.borrower)
      new_payment_page.load(loan_uuid: loan.uuid)
      new_payment_page.payment_form.submit(amount: '00')
    end

    scenario do
      expect(new_payment_page).to have_content(
        'must be larger than $0.00'
      )
    end
  end
end
