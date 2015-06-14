feature 'Create a loan', :js do
  let(:new_loan_page)   { Loans::NewPage.new }
  let(:show_loan_page)  { Loans::ShowPage.new }
  let(:sign_in_page)    { SignInPage.new }

  scenario 'as a new user' do
    new_loan_page.load
    new_loan_page.submit(
      amount_cents:   '00',
      amount_dollars: '10',
      creator_email:  Faker::Internet.email,
      obligor_email:  Faker::Internet.email
    )
    expect(show_loan_page).to be_displayed
  end

  scenario 'as a signed-out, extant user' do
    user = FactoryGirl.create(:user, :with_email)

    new_loan_page.load
    new_loan_page.submit(
      amount_cents:   '00',
      amount_dollars: '10',
      creator_email:  user.emails.first.email,
      obligor_email:  Faker::Internet.email
    )
    expect(sign_in_page).to be_displayed
  end

  scenario 'as as signed-in user' do
    user = FactoryGirl.create(:user, :with_email)
    login_as(user, scope: :user, run_callbacks: false)

    new_loan_page.load
    new_loan_page.submit(
      amount_cents:   '00',
      amount_dollars: '10',
      obligor_email:  Faker::Internet.email
    )
    expect(show_loan_page).to be_displayed
  end

  scenario 'invalid params' do
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

  scenario 'invalid params' do
    email = Faker::Internet.email

    new_loan_page.load
    new_loan_page.submit
    expect(new_loan_page).to have_content(
      I18n.t('errors.messages.nonpositive_amount'))
    expect(new_loan_page).to have_content(I18n.t('errors.messages.blank'))
  end
end
