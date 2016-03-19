class ApplicationParams
  include Lean::Params

  attribute :action,      String
  attribute :controller,  String
end
