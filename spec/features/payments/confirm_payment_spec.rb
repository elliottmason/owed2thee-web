feature 'Confirm a payment', :js do
  let(:payment) { FactoryGirl.create(:payment) }

  let(:show_payment_page)  { Payments::ShowPage.new }

  scenario 'as a payee' do
    login_as(payment.payees.first)
    show_payment_page.load(uuid: payment.uuid)
    show_payment_page.confirm

    expect(show_payment_page).to be_displayed
    expect(show_payment_page).to have_content(confirmation_notice)
    expect(show_payment_page).to_not have_confirm_button
  end

  scenario 'as payer' do
    login_as(payment.payer)
    show_payment_page.load(uuid: payment.uuid)
    show_payment_page.confirm

    expect(show_payment_page).to be_displayed
    expect(show_payment_page).to have_content(confirmation_notice)
    expect(show_payment_page).to_not have_confirm_button
  end

  def confirmation_notice
    I18n.t('controllers.application.confirm.flash.notice')
  end
end
