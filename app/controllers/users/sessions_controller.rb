module Users
  class SessionsController < Devise::SessionsController
    def create
      super do |user|
        confirm_loan_participation(user)
      end
    end

    private

    def confirm_loan_participation(user)
      ConfirmLoanParticipation.with(
        loan_id:  created_loan_id,
        user:     user
      ) if created_loan_id
    end

    def created_loan_id
      session[:created_loan_id]
    end
  end
end
