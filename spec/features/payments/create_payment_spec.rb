feature 'Create a payment for a loan', :js do
  let(:new_payment_page)  { Payments::NewPage.new }
  let(:show_loan_page)    { Loans::ShowPage.new }
  let(:show_payment_page) { Payments::ShowPage.new }

  let(:loan) { FactoryGirl.create(:published_loan) }

  scenario 'as a borrower' do
    login_as(loan.borrowers.first)
    show_loan_page.load(id: loan.id)
    expect(show_loan_page).to have_payment_button

    show_loan_page.payment_button.click
    expect(new_payment_page).to be_displayed

    new_payment_page.submit(
      amount_dollars: '10',
      amount_cents:   '00'
    )
    expect(show_payment_page).to be_displayed
  end

  scenario 'as a lender' do
    login_as(loan.lenders.first)
    show_loan_page.load(id: loan.id)
    expect(show_loan_page).to_not have_payment_button
  end

  scenario 'invalid params' do
    login_as(loan.borrowers.first)
    new_payment_page.load(id: loan.id)

    new_payment_page.submit(
      amount_dollars: '00',
      amount_cents:   '00'
    )
    expect(new_payment_page).to \
      have_content(I18n.t('errors.messages.nonpositive_amount'))
  end
end
