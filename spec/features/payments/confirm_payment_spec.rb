feature 'Confirm a payment', :js do
  let(:payment) do
    borrower  = FactoryGirl.create(:confirmed_user, first_name: 'Kyle')
    lender    = FactoryGirl.create(:confirmed_user, first_name: 'Josh')
    loan      = FactoryGirl.create(:confirmed_loan,
                                   amount:    4.44,
                                   borrower:  borrower,
                                   creator:   lender)
    FactoryGirl.create(:payment, amount: 1, payable: loan)
  end

  let(:show_payment_page)  { Payments::ShowPage.new }

  context 'as a payee' do
    let(:confirmation_notice) do
      'Confirmed a $1.00 payment from Kyle'
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
      "Confirmed your $1.00 payment toward Josh's loan for $4.44"
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
