require 'rails_helper'

feature 'Confirm a loan', :js do
  let(:borrower) do
    FactoryGirl.create(:confirmed_user, email_address: 'elliott@gmail.com')
  end
  let(:creator) { lender }
  let(:lender) do
    FactoryGirl.create(:confirmed_user,
                       email_address: 'josh@gmail.com',
                       first_name:    'Josh',
                       last_name:     nil)
  end
  let(:loan) do
    FactoryGirl.create(:loan, amount:   9.00,
                              borrower: borrower,
                              creator:  creator,
                              lender:   lender)
  end
  let(:sent_email) { ActionMailer::Base.deliveries.last }

  let(:show_loan_page) { Loans::ShowPage.new }

  context 'as its creator' do
    let(:confirmation_notice) { 'You confirmed your loan to elliott@gmail.com' }
    let(:current_user) { loan.creator }

    before do
      ActionMailer::Base.deliveries.clear
      confirm_loan
    end

    scenario do
      expect_loan_confirmation
      expect(sent_email.to).to match_array ['elliott@gmail.com']
      expect(sent_email.subject).
        to eq '[Owed2Thee] - Confirm your loan with Josh'
    end
  end

  context 'as its recipient borrower' do
    let(:confirmation_notice) { "You confirmed Josh's loan to you" }
    let(:current_user) { loan.borrower }

    before do
      PublishLoan.with(loan, loan.creator)
      confirm_loan
    end

    scenario do
      expect_loan_confirmation
      expect(sent_email.subject).
        to eq '[Owed2Thee] - elliott@gmail.com confirmed your loan'
    end
  end

  context 'as its recipient lender' do
    let(:confirmation_notice) { '' }
    let(:creator) { borrower }
    let(:current_user) { lender }

    before do
      PublishLoan.with(loan, loan.creator)
      confirm_loan
    end

    scenario do
      expect_loan_confirmation
      expect(sent_email.subject).
        to eq '[Owed2Thee] - Josh confirmed your loan'
    end
  end

  def confirm_loan
    login_as(current_user)
    show_loan_page.load(uuid: loan.uuid)
    perform_enqueued_jobs { show_loan_page.confirm }
  end

  def expect_loan_confirmation
    expect(show_loan_page).to be_displayed
    expect(show_loan_page).to have_content(confirmation_notice)
    expect(show_loan_page).to_not have_confirm_button
  end
end
