feature 'Submit a payment to a lender', :js do
  let(:new_payment_page)  { Payments::NewPage.new }
  let(:show_loan_page)    { Loans::ShowPage.new }
  let(:show_payment_page) { Payments::ShowPage.new }

  let(:loan) { FactoryGirl.create(:confirmed_loan) }

  scenario 'as a borrower' do
    login_as(loan.borrower)
    show_loan_page.load(uuid: loan.uuid)

    expect(show_loan_page).to have_payment_button

    show_loan_page.payment_button.click
    expect(new_payment_page).to be_displayed

    new_payment_page.payment_form.submit(
      FactoryGirl.attributes_for(:payment_form))

    expect(show_payment_page).to be_displayed
  end

  scenario 'as the lender' do
    login_as(loan.lender)
    show_loan_page.load(uuid: loan.uuid)

    expect(show_loan_page).to_not have_payment_button
  end

  scenario 'invalid params' do
    login_as(loan.borrower)
    new_payment_page.load(user_uuid: loan.lender.uuid)
    new_payment_page.payment_form.submit(amount: '00')

    expect(new_payment_page).to have_content(
      'must be larger than $0.00'
    )
  end
end
