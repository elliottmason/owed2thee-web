feature 'Create a loan', :js do
  let(:new_loan_page)   { Loans::NewPage.new }
  let(:show_loan_page)  { Loans::ShowPage.new }
  let(:sign_in_page)    { SignInPage.new }

  scenario 'as a new user' do
    new_loan_page.load
    new_loan_page.loan_form.submit(FactoryGirl.attributes_for(:loan_form))
    expect(show_loan_page).to be_displayed
  end

  scenario 'as a signed-out user' do
    user = FactoryGirl.create(:confirmed_user)
    obligor_email_address = \
      FactoryGirl.create(:confirmed_user).primary_email_address.address

    new_loan_page.load
    new_loan_page.loan_form.submit(
      FactoryGirl.attributes_for(
        :loan_form,
        creator_email_address: user.primary_email_address.address,
        obligor_email_address: obligor_email_address
      )
    )
    expect(sign_in_page).to be_displayed

    sign_in_page.sign_in_form.submit(
      password: user.password
    )

    expect(show_loan_page).to be_displayed
  end

  scenario 'as a signed-out, unconfirmed user' do
    user = FactoryGirl.create(:unconfirmed_user)

    obligor_email_address = \
      FactoryGirl.create(:confirmed_user).primary_email_address.address

    new_loan_page.load
    new_loan_page.loan_form.submit(
      FactoryGirl.attributes_for(
        :loan_form,
        creator_email_address: user.primary_email_address.address,
        obligor_email_address: obligor_email_address
      )
    )
    expect(sign_in_page).to be_displayed
    expect(sign_in_page).to_not have_sign_in_form
  end

  scenario 'as as signed-in user' do
    user = FactoryGirl.create(:confirmed_user)
    login_as(user, scope: :user, run_callbacks: false)

    new_loan_page.load
    new_loan_page.loan_form.submit(
      FactoryGirl.attributes_for(:loan_form).except(:creator_email_address)
    )
    expect(show_loan_page).to be_displayed
  end

  scenario 'creator and obligor emails the same' do
    email_address = Faker::Internet.email

    new_loan_page.load
    new_loan_page.loan_form.submit(
      creator_email_address: email_address,
      obligor_email_address: email_address
    )
    expect(new_loan_page) \
      .to have_content('you cannot create a loan with yourself')
  end

  context 'with no amount' do
    scenario do
      new_loan_page.load
      new_loan_page.loan_form.submit
      expect(new_loan_page).to have_content('must be larger than $0.00')
    end
  end

  scenario 'borrowers are the same' do
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
    expect(new_loan_page) \
      .to have_content('you cannot create a loan with yourself')
  end

  scenario 'lenders are the same' do
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
    expect(new_loan_page) \
      .to have_content('you cannot create a loan with yourself')
  end
end
