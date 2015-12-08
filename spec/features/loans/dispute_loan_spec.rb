feature 'Dispute a loan', :devise, :js do
  let(:loan) do
    creator = FactoryGirl.create(
      :confirmed_user,
      first_name: 'Josh',
      last_name: 'Schramm'
    )
    CreateLoan.with(
      creator,
      FactoryGirl.attributes_for(
        :loan_form,
        amount: '4.44'
      )
    ).loan
  end

  let(:show_loan_page) { Loans::ShowPage.new }

  before do
    PublishLoan.with(loan, loan.creator)
  end

  scenario 'as a borrower' do
    login_as(loan.borrower)
    show_loan_page.load(uuid: loan.uuid)
    show_loan_page.dispute

    expect(show_loan_page).to be_displayed
    expect(show_loan_page).to have_content(
      "Your dispute against Josh Schramm's loan for $4.44 has been submitted"
    )
    expect(show_loan_page).to_not have_dispute_button
    expect(show_loan_page).to have_confirm_button
  end
end
