class LoanParticipant < ActiveRecord::Base
  include Confirmable

  belongs_to :loan, inverse_of: false
  belongs_to :user, class_name: 'User', inverse_of: :loan_borrowers

  def to_param
    loan_id
  end
end
