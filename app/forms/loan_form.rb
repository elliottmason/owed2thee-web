class LoanForm < BaseForm
  define_attributes initialize: true, attributes: true do
    attribute :amount_cents,    Integer
    attribute :amount_dollars,  Integer
    attribute :creator_email,   String
    attribute :obligor_email,   String
    attribute :type,            String
  end
end
