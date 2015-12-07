feature 'Confirm a payment', :js do
  let(:payment) do
    payer = FactoryGirl.create(
      :confirmed_user,
      email_address: 'kyle.balderson@gmail.com'
    )
    payee = FactoryGirl.create(
      :confirmed_user,
      first_name: 'Josh',
      last_name:  'Schramm'
    )
    FactoryGirl.create(:payment, amount: 1, payee: payee, payer: payer)
  end

  let(:show_payment_page) { Payments::ShowPage.new }

  context 'as a payee' do
    let(:confirmation_notice) do
      "You confirmed kyle.balderson@gmail.com's $1.00 payment toward your " \
      'loan for $4.44'
    end

    scenario do
      login_as(payment.payee)
      show_payment_page.load(uuid: payment.uuid)
      show_payment_page.confirm

      expect_confirmation_notice
    end
  end

  context 'as payer' do
    let(:confirmation_notice) do
      "You confirmed your $1.00 payment toward Josh Schramm's loan for $4.44"
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
