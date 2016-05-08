require 'rails_helper'

feature 'Confirm a loan', :js do
  let(:show_loan_page) { Loans::ShowPage.new }

  context 'as as lender' do
    let(:confirmation_notice) { 'You confirmed your loan to elliott@gmail.com' }
    let(:current_user) { loan.lender }
    let(:loan) do
      borrower = FactoryGirl.create(:confirmed_user,
                                    email_address: 'elliott@gmail.com')
      FactoryGirl.create(:loan, amount: 9.00, borrower: borrower)
    end

    before do
      confirm_loan
    end

    scenario do
      expect_loan_confirmation
    end
  end

  context 'as a borrower' do
    let(:confirmation_notice) { "You confirmed Josh's loan to you" }
    let(:current_user) { loan.borrower }
    let(:loan) do
      lender = FactoryGirl.create(:confirmed_user, first_name:  'Josh',
                                                   last_name:   nil)
      FactoryGirl.create(:published_loan, creator: lender)
    end

    before do
      confirm_loan
    end

    scenario do
      expect_loan_confirmation
    end
  end

  def confirm_loan
    login_as(current_user)
    show_loan_page.load(uuid: loan.uuid)
    show_loan_page.confirm
  end

  def expect_loan_confirmation
    expect(show_loan_page).to be_displayed
    expect(show_loan_page).to have_content(confirmation_notice)
    expect(show_loan_page).to_not have_confirm_button
  end
end
