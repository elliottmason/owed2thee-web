feature 'Set login password', :devise, :js do
  let(:edit_password_page) { Accounts::Passwords::EditPage.new }

  context 'with no existing password' do
    let(:user) { FactoryGirl.create(:unconfirmed_user) }

    scenario do
      login_as(user)
      edit_password_page.load

      edit_password_page.password_form.submit(
        new_password:               'abcd1234',
        new_password_confirmation:  'abcd1234'
      )

      expect(edit_password_page).to be_displayed
      # expect flash message
    end
  end

  context 'with existing password' do
    let(:user) { FactoryGirl.create(:confirmed_user) }

    before do
      login_as(user)
      edit_password_page.load
    end

    scenario 'valid current password' do
      edit_password_page.password_form.submit(
        current_password:           user.password,
        new_password:               'abcd1234',
        new_password_confirmation:  'abcd1234'
      )

      expect(edit_password_page).to be_displayed
      # expect flash message
    end

    scenario 'with incorrect current password' do
      edit_password_page.password_form.submit(
        current_password:           'butts',
        new_password:               'abcd1234',
        new_password_confirmation:  'abcd1234'
      )
      expect(edit_password_page).to_not be_displayed
      # expect error flash message
    end
  end
end
