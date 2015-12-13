feature 'Setting login password', :devise, :js do
  let(:edit_password_page) { Accounts::Passwords::EditPage.new }

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

    scenario do
      expect(edit_password_page).to be_displayed
    end

    pending 'expect flash message'
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
          current_password:           user.password,
          new_password:               'abcd1234',
          new_password_confirmation:  'abcd1234'
        )
      end

      scenario { expect(edit_password_page).to be_displayed }
      pending 'expect flash message'
    end

    context 'but incorrect current password' do
      before do
        edit_password_page.password_form.submit(
          current_password:           'butts',
          new_password:               'abcd1234',
          new_password_confirmation:  'abcd1234'
        )
      end
      scenario { expect(edit_password_page).to_not be_displayed }
      pending 'expect flash message'
    end
  end
end
