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

    new_loan_page.load
    new_loan_page.submit(
      FactoryGirl.attributes_for(
        :loan_form,
        creator_email: user.emails.first.email,
        obligor_email: FactoryGirl.create(:confirmed_user).emails.first.email
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
      FactoryGirl.attributes_for(:loan_form).except(:creator_email)
    )
    expect(show_loan_page).to be_displayed
  end

  scenario 'creator and obligor emails the same' do
    email = Faker::Internet.email

    new_loan_page.load
    new_loan_page.submit(
      creator_email: email,
      obligor_email: email
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
    user.emails << FactoryGirl.build(:user_email)

    new_loan_page.load
    new_loan_page.submit(
      FactoryGirl.attributes_for(
        :loan_form,
        creator_email:  user.emails.first.email,
        obligor_email:  user.emails.last.email,
        type:           'debt'
      )
    )
    expect(new_loan_page).to have_content('you a bitch')
  end

  scenario 'lenders are the same' do
    user = FactoryGirl.create(:confirmed_user)
    user.emails << FactoryGirl.build(:user_email)

    new_loan_page.load
    new_loan_page.submit(
      FactoryGirl.attributes_for(
        :loan_form,
        creator_email: user.emails.first.email,
        obligor_email: user.emails.last.email
      )
    )
    expect(new_loan_page).to have_content('you a bitch')
  end
end
