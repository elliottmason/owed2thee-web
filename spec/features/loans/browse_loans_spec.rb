feature 'Browsing loans', :js do
  let(:loans_index_page) { Loans::IndexPage.new }
  let(:user) { create(:confirmed_user) }

  context 'while signed in' do
    before do
      login_as(user)
    end

    context 'with a long history of loans' do
      before do
        create_list(:confirmed_loan, 10, creator: user)
      end

      scenario 'is paginated' do
        loans_index_page.load
        loans_index_page.pagination.click_page(2)

        expect(loans_index_page.current_page).to eq 2
      end
    end
  end
end
