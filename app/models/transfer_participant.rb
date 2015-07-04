# TransferParticipant acts as a join model between a user and a transfer. For
# example, a Loan will have at least one LoanLender and one LoanBorrower, both
# subclasses of TransferParticipant.
class TransferParticipant < ActiveRecord::Base
  include Transitional

  belongs_to :email, class_name: 'EmailAddress'
  belongs_to :participable, polymorphic: true
  belongs_to :user

  transitional :confirmation, state_machine_class_name: 'DisputeStateMachine'
end
