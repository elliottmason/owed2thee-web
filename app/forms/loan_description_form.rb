class LoanDescriptionForm < ApplicationForm
  include ActiveModel::Validations

  attribute :body,  String
  attribute :loan,  Loan

  validates :body, length: { in: 2..5000 }
end
