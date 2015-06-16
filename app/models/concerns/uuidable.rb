module Uuidable
  def self.included(base)
    base.class_eval do
      before_create :generate_uuid
    end
  end

  def generate_uuid
    self[:uuid] ||= SecureRandom.uuid
  end

  def to_param
    uuid
  end
end
