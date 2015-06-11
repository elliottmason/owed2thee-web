feature 'Confirm email address', :devise, :js do
  let(:user) { FactoryGirl.create(:user_with_email) }
  let(:user_email) { user.emails.first }

  let(:confirm_email_page) { ConfirmEmailPage.new }

  scenario 'with correct confirmation token' do
    confirm_email_page.load(confirmation_token: user_email.confirmation_token,
                            email: user_email.email)
  end
end
