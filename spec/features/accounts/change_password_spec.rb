feature 'Setting login password', :devise, :js do
  let(:current_password) { user.password }
  let(:edit_password_page) { Accounts::Passwords::EditPage.new }
  let(:failure_notice) { I18n.t('passwords.notices.update_failure') }
  let(:success_notice) { I18n.t('passwords.notices.update_success') }

  context 'with no current password' do
    let(:user) { FactoryGirl.create(:unconfirmed_user) }

    before do
      login_as(user)
      edit_password_page.load

      edit_password_page.password_form.submit(
        new_password:               'abcd1234',
        new_password_confirmation:  'abcd1234'
      )
    end

    scenario 'is successful' do
      expect(edit_password_page).to be_displayed
      expect(edit_password_page).to have_content success_notice
    end
  end

  context 'with an extant password' do
    let(:user) { FactoryGirl.create(:confirmed_user) }

    before do
      login_as(user)
      edit_password_page.load
    end

    context 'and correct current password' do
      before do
        edit_password_page.password_form.submit(
          current_password:           current_password,
          new_password:               'abcd1234',
          new_password_confirmation:  'abcd1234'
        )
      end

      scenario 'is successful' do
        expect(edit_password_page).to be_displayed
        expect(edit_password_page).to have_content success_notice
      end
    end

    context 'but incorrect current password' do
      before do
        edit_password_page.password_form.submit(
          current_password:           'butts',
          new_password:               'abcd1234',
          new_password_confirmation:  'abcd1234'
        )
      end

      scenario 'is unsuccessful' do
        expect(edit_password_page).to_not be_displayed
        expect(edit_password_page).to have_content failure_notice
      end
    end
  end
end
