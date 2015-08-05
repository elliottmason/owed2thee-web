feature 'Confirm a loan', js: true do
  let(:confirmation_notice) { 'Dongs' }
  let(:show_loan_page)  { Loans::ShowPage.new }

  context 'as as lender' do
    let(:loan) { FactoryGirl.create(:loan) }

    scenario do
      confirm_loan
      expect_loan_confirmation
    end
  end

  context 'as a borrower' do
    let(:loan) { FactoryGirl.create(:debt) }

    scenario do
      confirm_loan
      expect_loan_confirmation
    end
  end

  def confirm_loan
    login_as(loan.creator)
    show_loan_page.load(uuid: loan.uuid)
    show_loan_page.confirm
  end

  def expect_loan_confirmation
    expect(show_loan_page).to be_displayed
    expect(show_loan_page).to_not have_content(confirmation_notice)
    expect(show_loan_page).to_not have_confirm_button
  end
end
