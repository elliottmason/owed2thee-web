feature 'Create a loan', :js do
  let(:new_loan_page)   { Loans::NewPage.new }
  let(:show_loan_page)  { Loans::ShowPage.new }
  let(:sign_in_page)    { SignInPage.new }

  scenario 'as a new user' do
    new_loan_page.load
    new_loan_page.submit(FactoryGirl.attributes_for(:loan_form))
    expect(show_loan_page).to be_displayed
  end

  scenario 'as a signed-out, extant user' do
    user = FactoryGirl.create(:confirmed_user)
    obligor_email_address = \
      FactoryGirl.create(:confirmed_user).primary_email_address

    new_loan_page.load
    new_loan_page.submit(
      FactoryGirl.attributes_for(
        :loan_form,
        creator_email_address: user.primary_email_address,
        obligor_email_address: obligor_email_address
      )
    )
    expect(sign_in_page).to be_displayed

    sign_in_page.submit(
      password: user.password
    )

    expect(show_loan_page).to be_displayed
  end

  scenario 'as as signed-in user' do
    user = FactoryGirl.create(:user, :with_email)
    login_as(user, scope: :user, run_callbacks: false)

    new_loan_page.load
    new_loan_page.submit(
      FactoryGirl.attributes_for(:loan_form).except(:creator_email_address)
    )
    expect(show_loan_page).to be_displayed
  end

  scenario 'creator and obligor emails the same' do
    email_address = Faker::Internet.email

    new_loan_page.load
    new_loan_page.submit(
      creator_email_address: email_address,
      obligor_email_address: email_address
    )
    expect(new_loan_page).to have_content(
      I18n.t('errors.messages.identical_users', record: 'loan'))
    expect(new_loan_page).to have_content(
      I18n.t('errors.messages.nonpositive_amount'))
  end

  scenario 'amount zero or less' do
    new_loan_page.load
    new_loan_page.submit
    expect(new_loan_page).to \
      have_content(I18n.t('errors.messages.nonpositive_amount'))
    expect(new_loan_page).to have_content(I18n.t('errors.messages.blank'))
  end

  scenario 'borrowers are the same' do
    user = FactoryGirl.create(:confirmed_user)
    user.email_addresses << FactoryGirl.build(:email_address)

    new_loan_page.load
    new_loan_page.submit(
      FactoryGirl.attributes_for(
        :loan_form,
        creator_email_address:  user.email_addresses.first.address,
        obligor_email_address:  user.email_addresses.last.address,
        type:                   'debt'
      )
    )
    expect(new_loan_page).to have_content('you a bitch')
  end

  scenario 'lenders are the same' do
    user = FactoryGirl.create(:confirmed_user)
    user.email_addresses << FactoryGirl.build(:email_address)

    new_loan_page.load
    new_loan_page.submit(
      FactoryGirl.attributes_for(
        :loan_form,
        creator_email_address: user.email_addresses.first.address,
        obligor_email_address: user.email_addresses.last.address
      )
    )
    expect(new_loan_page).to have_content('you a bitch')
  end
end
