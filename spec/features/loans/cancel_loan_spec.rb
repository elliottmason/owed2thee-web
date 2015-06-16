feature 'Cancel a loan', js: true do
  let(:loan) { FactoryGirl.create(:loan) }

  let(:show_loan_page)  { Loans::ShowPage.new }

  scenario 'as the creator' do
    login_as(loan.creator)
    show_loan_page.load(uuid: loan.uuid)
    show_loan_page.cancel

    expect(show_loan_page).to have_content(cancellation_notice)
    expect(show_loan_page).to be_displayed
    expect(show_loan_page).to_not have_cancel_button
  end

  def cancellation_notice
    I18n.t('controllers.application.cancel.flash.notice')
  end
end
