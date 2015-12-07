module DisputeItem
  def self.included(base)
    base.class_eval do
      transition :dispute
    end
  end
end
