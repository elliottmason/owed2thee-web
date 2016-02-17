class CommentForm < ApplicationForm
  include ActiveModel::Validations

  attribute :body,    String
  attribute :subject, String

  validates :body, length: { in: 2..5000 }
end
