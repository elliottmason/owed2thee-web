feature 'Confirm a loan', js: true do
  let(:show_loan_page)  { Loans::ShowPage.new }

  context 'as as lender' do
    let(:confirmation_notice) { 'Confirmed your loan to Josh for $9.00' }
    let(:current_user) { loan.lender }
    let(:loan) do
      lender = FactoryGirl.create(:confirmed_user, first_name: 'Josh')
      FactoryGirl.create(:loan, amount: 9.00, creator: lender)
    end

    scenario do
      confirm_loan
      expect_loan_confirmation
    end
  end

  context 'as a borrower' do
    let(:confirmation_notice) { "Confirmed Josh's loan for $9.00" }
    let(:current_user) { loan.borrower }
    let(:loan) { FactoryGirl.create(:published_loan) }

    scenario do
      confirm_loan
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
    expect(show_loan_page).to_not have_content(confirmation_notice)
    expect(show_loan_page).to_not have_confirm_button
  end
end
