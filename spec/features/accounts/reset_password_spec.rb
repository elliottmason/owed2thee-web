require 'rails_helper'

feature 'Reset login password', :devise, :js do
  let(:confirmation_token)  { password_reset.confirmation_token }
  let(:current_password)    { user.password }
  let(:edit_password_page)  { Accounts::Passwords::EditPage.new }
  let(:success_notice) { 'Your new password has been set and is now active.' }

  before do
    edit_password_page.load(confirmation_token: confirmation_token)
  end

  context 'with valid confirmation token' do
    let(:password_reset) { create(:password_reset) }

    before do
      edit_password_page.reset_password_to('password12345')
    end

    scenario 'confirms password change' do
      expect(edit_password_page).to have_content success_notice
    end
  end

  context 'with expired confirmation token' do
    let(:password_reset) { create(:password_reset, :expired) }
  end
end
