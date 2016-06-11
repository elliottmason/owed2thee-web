require 'rails_helper'

feature 'Creating a loan', :background, :js do
  let(:new_loan_page)   { Loans::NewPage.new }
  let(:show_loan_page)  { Loans::ShowPage.new }
  let(:sign_in_page)    { SignInPage.new }

  before do
    ActionMailer::Base.deliveries.clear
  end

  context 'as a new user' do
    def submit_form
      new_loan_page.loan_form.submit(FactoryGirl.attributes_for(:loan_form))
    end

    before do
      ActionMailer::Base.deliveries.clear
      new_loan_page.load
      perform_enqueued_jobs do
        submit_form
      end
    end

    scenario do
      expect(show_loan_page).to be_displayed
    end

    scenario do
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(ActionMailer::Base.deliveries[0].subject).
        to eq '[Owed2Thee] - Confirm your email address'
    end
  end

  context "as a confirmed user for another confirmed user's email address" do
    let(:borrower)  { FactoryGirl.create(:confirmed_user) }
    let(:creator)   { FactoryGirl.create(:confirmed_user) }

    before do
      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(
          :loan_form,
          amount: 10,
          creator_email_address: creator.primary_email_address.address,
          obligor_email_address: borrower.primary_email_address.address
        )
      )
    end

    scenario { expect(sign_in_page).to be_displayed }

    context 'with correct signin password' do
      before do
        sign_in_page.sign_in_form.submit(
          password: creator.password
        )
      end

      scenario { expect(show_loan_page).to be_displayed }
    end
  end

  context 'using a known, but unconfirmed email address' do
    let(:creator) { FactoryGirl.create(:unconfirmed_user, sign_in_count: 1) }

    before do
      new_loan_page.load
      perform_enqueued_jobs do
        new_loan_page.loan_form.submit(
          FactoryGirl.attributes_for(
            :loan_form,
            creator_email_address: creator.primary_email_address.address
          )
        )
      end
    end

    scenario do
      expect(sign_in_page).to be_displayed
      expect(sign_in_page).to_not have_sign_in_form
      expect(ActionMailer::Base.deliveries.size).to be >= 1
      expect(ActionMailer::Base.deliveries.last.subject).
        to eq '[Owed2Thee] - How to sign in and set your password'
    end
  end

  context 'while signed in' do
    let(:current_user) { FactoryGirl.create(:confirmed_user) }

    before do
      login_as(current_user, scope: :user, run_callbacks: false)

      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(:loan_form).except(:creator_email_address)
      )
    end

    scenario { expect(show_loan_page).to be_displayed }
  end

  context 'creator and obligor emails the same' do
    before do
      email_address = Faker::Internet.email

      new_loan_page.load
      new_loan_page.loan_form.submit(
        creator_email_address: email_address,
        obligor_email_address: email_address
      )
    end

    scenario do
      expect(new_loan_page).
        to have_content('you cannot create a loan with yourself')
    end
  end

  context 'with no amount' do
    scenario do
      new_loan_page.load
      new_loan_page.loan_form.submit
      expect(new_loan_page).to have_content('must be larger than $0.00')
    end
  end

  context 'borrowers are the same' do
    before do
      user = FactoryGirl.create(:confirmed_user)
      user.email_addresses << FactoryGirl.build(:email_address)

      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(
          :loan_form,
          creator_email_address:  user.email_addresses.first.address,
          obligor_email_address:  user.email_addresses.last.address,
          type:                   'debt'
        )
      )
    end

    scenario do
      expect(new_loan_page).
        to have_content('you cannot create a loan with yourself')
    end
  end

  context 'lenders are the same' do
    before do
      user = FactoryGirl.create(:confirmed_user)
      user.email_addresses << FactoryGirl.build(:email_address)

      new_loan_page.load
      new_loan_page.loan_form.submit(
        FactoryGirl.attributes_for(
          :loan_form,
          creator_email_address: user.email_addresses.first.address,
          obligor_email_address: user.email_addresses.last.address
        )
      )
    end

    scenario do
      expect(new_loan_page).
        to have_content('you cannot create a loan with yourself')
    end
  end
end
