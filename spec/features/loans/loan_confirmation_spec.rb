feature 'Confirm a loan', js: true do
  let(:loan) { FactoryGirl.create(:loan) }

  let(:show_loan_page)  { Loans::ShowPage.new }

  scenario 'as a lender' do
    login_as(loan.lenders.first)
    show_loan_page.load(id: loan.id)
    show_loan_page.confirm

    expect(show_loan_page).to be_displayed
    expect(show_loan_page).to have_content(confirmation_notice)
    expect(show_loan_page).to_not have_confirm_button
  end

  scenario 'as a borrower' do
    loan.publish!
    login_as(loan.borrowers.first)
    show_loan_page.load(id: loan.id)
    show_loan_page.confirm

    expect(show_loan_page).to be_displayed
    expect(show_loan_page).to have_content(confirmation_notice)
    expect(show_loan_page).to_not have_confirm_button
  end

  def confirmation_notice
    I18n.t('controllers.application.confirm.flash.notice')
  end
end
