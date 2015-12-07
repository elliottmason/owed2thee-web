feature 'Dispute a loan', :devise, :js do
  let(:loan) do
    creator = FactoryGirl.create(
      :confirmed_user,
      first_name: 'Josh',
      last_name: 'Schramm'
    )
    FactoryGirl.create(:published_loan, amount: 4.44, creator: creator)
  end

  let(:show_loan_page) { Loans::ShowPage.new }

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
