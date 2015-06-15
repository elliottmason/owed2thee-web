module Users
  class SessionsController < Devise::SessionsController
    def new
      @sign_in_form = SignInForm.new(email: session[:user_email])
    end

    def create
      super do |user|
        confirm_loan_participation(user)
      end
    end

    private

    def confirm_loan_participation(user)
      ConfirmLoanParticipation.with(user, created_loan) if created_loan
    end

    def created_loan
      Loan.where(id: created_loan_id).first if created_loan_id
    end

    def created_loan_id
      session[:created_loan_id]
    end
  end
end
