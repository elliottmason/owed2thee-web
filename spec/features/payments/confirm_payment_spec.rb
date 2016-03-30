require 'rails_helper'

feature 'Confirm a payment', :js do
  let(:borrower)  { payer }
  let(:creator)   { payer }
  let(:lender)    { payee }
  let(:payee) do
    FactoryGirl.create(
      :confirmed_user,
      first_name: 'Josh',
      last_name:  'Schramm'
    )
  end
  let(:payer) do
    FactoryGirl.create(
      :confirmed_user,
      email_address:  'kyle.balderson@gmail.com',
      first_name:     nil,
      last_name:      nil
    )
  end
  let!(:payment) do
    CreatePayment.with(
      payer,
      payee,
      FactoryGirl.attributes_for(
        :payment_form,
        amount:   1
      )
    ).payment
  end

  let(:show_payment_page) { Payments::ShowPage.new }

  before do
    loan = CreateLoan.with(
      lender,
      FactoryGirl.attributes_for(
        :loan_form,
        obligor_email_address: borrower.primary_email_address.address
      )
    ).loan
    PublishLoan.with(loan, lender)
  end

  context 'as a payee' do
    let(:confirmation_notice) do
      "You confirmed kyle.balderson@gmail.com's $1.00 payment to you"
    end

    before do
      PublishPayment.with(payment, creator)
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
      'You confirmed your $1.00 payment to Josh Schramm'
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
