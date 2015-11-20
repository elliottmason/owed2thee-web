feature 'Reset forgotten password', :devise, :js do
  let(:email_address) { user.primary_email_address.address }
  let(:user) do
    FactoryGirl.create(:unconfirmed_user,
                       email_address: 'josh.schramm@gmail.com')
  end

  feature 'request password' do
    let(:forgot_password_page) { Accounts::Passwords::ForgotPage.new }
    let(:confirmation_page) { Accounts::Passwords::ForgotConfirmationPage.new }
    let(:sign_in_page)      { SignInPage.new }

    before do
      ActionMailer::Base.deliveries.clear
    end

    scenario 'for known email address' do
      sign_in_page.load
      sign_in_page.forgot_password_link.click
      expect(forgot_password_page).to be_displayed
      forgot_password_page.email_form.email_address_field.set(email_address)
      forgot_password_page.email_form.submit

      expect(confirmation_page).to be_displayed
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    pending 'for unknown email address' do
      forgot_password_page.load
      forgot_password_page.email_form.email_address_field.set('fake@false.co')
      forgot_password_page.email_form.submit

      expect(forgot_password_page).to be_displayed
      expect(forgot_password_page.email_form).to be_visible
      expect(ActionMailer::Base.deliveries.size).to be_zero
    end
  end

  feature 'change password' do
    let(:change_password_page) { Accounts::Password::EditPage.new }

    pending 'with valid token'
    pending 'with expired token'
    pending 'with redeemed token'
  end
end
