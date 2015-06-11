feature 'Dispute a loan', :devise, :js do
  let(:loan) { FactoryGirl.create(:loan) }

  let(:show_loan_page)  { Loans::ShowPage.new }

  scenario 'as a borrower' do
    loan.publish!
    login_as(loan.borrowers.first)
    show_loan_page.load(id: loan.id)
    show_loan_page.dispute

    expect(show_loan_page).to be_displayed
    expect(show_loan_page).to have_content(dispute_notice)
    expect(show_loan_page).to_not have_dispute_button
    expect(show_loan_page).to have_confirm_button
  end

  def dispute_notice
    I18n.t('controllers.application.dispute.flash.notice')
  end
end
