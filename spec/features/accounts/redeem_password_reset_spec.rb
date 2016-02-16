feature 'Following a link to reset forgotten password', :devise, :js do
  let!(:confirmation_token) { password_reset.confirmation_token }
  let(:email_address)       { user.primary_email_address }
  let(:password_reset) do
    CreatePasswordReset.with(email_address).password_reset
  end
  let(:user) do
    FactoryGirl.create(:unconfirmed_user,
                       email_address: 'josh.schramm@gmail.com')
  end

  let(:edit_password_page) { Accounts::Passwords::EditPage.new }
  let(:sign_in_page) { SignInPage.new }

  context 'with unredeemed and unexpired confirmation token' do
    scenario 'signs the user in and redirects to the edit password page' do
      visit "sign_in/#{confirmation_token}"

      expect(edit_password_page).to be_displayed
    end
  end

  context 'with a redeemed confirmation token' do
    before do
      RedeemTemporarySignin.with(password_reset)
    end

    scenario 'redirects to the signin page' do
      visit "sign_in/#{confirmation_token}"

      expect(sign_in_page).to be_displayed
    end
  end

  context 'with an expired confirmation token' do
    scenario 'redirects to the signin page' do
      Timecop.travel(8.days.from_now)

      visit "sign_in/#{confirmation_token}"

      expect(sign_in_page).to be_displayed
    end
  end

  context 'with an unknown confirmation token' do
    scenario 'redirects to the signin page' do
      visit 'sign_in/buttsbuttsbutts'

      expect(sign_in_page).to be_displayed
    end
  end
end
