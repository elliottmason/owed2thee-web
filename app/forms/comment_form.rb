class CommentForm < BaseForm
  include ActiveModel::Validations

  define_attributes initialize: true, attributes: true do
    attribute :body,    String
    attribute :subject, String
  end

  validates :body, length: { in: 2..5000 }
end
