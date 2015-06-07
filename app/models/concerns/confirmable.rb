module Confirmable
  def self.included(base)
    base.class_eval do
      scope :confirmable, lambda {
        where('confirmed_at IS NULL') \
          .where('confirmation_token IS NOT NULL') \
          .where('confirmation_sent_at <= ?', 7.days.ago)
      }
      scope :confirmed, -> { where('confirmed_at IS NOT NULL') }
    end
  end

  def confirm
    self[:confirmed_at] = Time.zone.now
  end

  def confirm!
    confirm
    save!
  end

  def confirmed?
    confirmed_at && confirmed_at <= Time.zone.now
  end

  def uncomfirmed?
    !confirmed?
  end
end
