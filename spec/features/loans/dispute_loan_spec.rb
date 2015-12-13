feature 'Disputing a loan', :devise, :js do
  let(:creator) do
    FactoryGirl.create(
      :confirmed_user,
      first_name: 'Josh',
      last_name: 'Schramm'
    )
  end
  let(:loan) do
    FactoryGirl.create(:published_loan, amount: 4.44, creator: creator)
  end

  let(:show_loan_page) { Loans::ShowPage.new }

  before do
    PublishLoan.with(loan, loan.creator)
    login_as(current_user)
    show_loan_page.load(uuid: loan.uuid)
  end

  context 'as an obligor' do
    let(:current_user) { loan.borrower }

    before do
      show_loan_page.dispute
    end

    scenario 'shows confirmation on loan page' do
      expect(show_loan_page).to be_displayed
      expect(show_loan_page).to have_content(
        "Your dispute against Josh Schramm's loan for $4.44 has been submitted"
      )
      expect(show_loan_page).to_not have_dispute_button
      expect(show_loan_page).to have_confirm_button
    end
  end

  context 'as the creator' do
    let(:current_user) { loan.lender }

    scenario "doesn't show dispute button" do
      expect(show_loan_page).to_not have_dispute_button
      expect(show_loan_page).to_not have_confirm_button
    end
  end
end
