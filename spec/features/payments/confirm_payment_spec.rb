feature 'Confirm a payment', :js do
  let(:payment) { FactoryGirl.create(:payment) }

  let(:show_payment_page)  { Payments::ShowPage.new }

  context 'as a payee' do
    let(:confirmation_notice) do
      '$10.00 payment from Josh is now confirmed'
    end

    scenario do
      login_as(payment.payees.first)
      show_payment_page.load(uuid: payment.uuid)
      show_payment_page.confirm

      expect_confirmation_notice
    end
  end

  context 'as payer' do
    let(:confirmation_notice) do
      'Your $10.00 payment to Josh is now confirmed'
    end

    scenario do
      login_as(payment.payer)
      show_payment_page.load(uuid: payment.uuid)
      show_payment_page.confirm

      expect_confirmation_notice
    end
  end

  def expect_confirmation_notice
    expect(show_payment_page).to be_displayed
    expect(show_payment_page).to have_content(confirmation_notice)
    expect(show_payment_page).to_not have_confirm_button
  end
end
