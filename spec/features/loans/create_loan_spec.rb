feature 'Creating a loan', :js do
  let(:new_loan_page)   { Loans::NewPage.new }
  let(:show_loan_page)  { Loans::ShowPage.new }
  let(:sign_in_page)    { SignInPage.new }

  context 'as a new user' do
    before do
      new_loan_page.load
      new_loan_page.loan_form.submit(FactoryGirl.attributes_for(:loan_form))
    end

    scenario { expect(show_loan_page).to be_displayed }
  end

  context "with a confirmed user's email address" do
    let(:borrower)  { FactoryGirl.create(:confirmed_user) }
    let(:creator)   { FactoryGirl.create(:confirmed_user) }
    let(:ledger)    { LedgerQuery.between!(borrower, creator) }

    before do
      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(
          :loan_form,
          amount: 10,
          creator_email_address: creator.primary_email_address.address,
          obligor_email_address: borrower.primary_email_address.address
        )
      )
    end

    scenario { expect(sign_in_page).to be_displayed }

    context 'with correct signin password' do
      before do
        sign_in_page.sign_in_form.submit(
          password: creator.password
        )
      end

      scenario { expect(show_loan_page).to be_displayed }
    end
  end

  context "with an unconfirmed user's email address" do
    before do
      user = FactoryGirl.create(:unconfirmed_user)

      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(
          :loan_form,
          creator_email_address: user.primary_email_address.address
        )
      )
    end

    scenario do
      expect(sign_in_page).to be_displayed
      expect(sign_in_page).to_not have_sign_in_form
    end
  end

  context 'while signed in' do
    let(:current_user) { FactoryGirl.create(:confirmed_user) }

    before do
      login_as(current_user, scope: :user, run_callbacks: false)

      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(:loan_form).except(:creator_email_address)
      )
    end

    scenario { expect(show_loan_page).to be_displayed }
  end

  context 'creator and obligor emails the same' do
    before do
      email_address = Faker::Internet.email

      new_loan_page.load
      new_loan_page.loan_form.submit(
        creator_email_address: email_address,
        obligor_email_address: email_address
      )
    end

    scenario do
      expect(new_loan_page).
        to have_content('you cannot create a loan with yourself')
    end
  end

  context 'with no amount' do
    scenario do
      new_loan_page.load
      new_loan_page.loan_form.submit
      expect(new_loan_page).to have_content('must be larger than $0.00')
    end
  end

  context 'borrowers are the same' do
    before do
      user = FactoryGirl.create(:confirmed_user)
      user.email_addresses << FactoryGirl.build(:email_address)

      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(
          :loan_form,
          creator_email_address:  user.email_addresses.first.address,
          obligor_email_address:  user.email_addresses.last.address,
          type:                   'debt'
        )
      )
    end

    scenario do
      expect(new_loan_page) \
        .to have_content('you cannot create a loan with yourself')
    end
  end

  context 'lenders are the same' do
    before do
      user = FactoryGirl.create(:confirmed_user)
      user.email_addresses << FactoryGirl.build(:email_address)

      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(
          :loan_form,
          creator_email_address: user.email_addresses.first.address,
          obligor_email_address: user.email_addresses.last.address
        )
      )
    end

    scenario do
      expect(new_loan_page) \
        .to have_content('you cannot create a loan with yourself')
    end
  end
end
