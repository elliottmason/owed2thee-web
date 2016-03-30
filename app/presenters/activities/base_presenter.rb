module Activities
  class BasePresenter < ApplicationPresenter
    delegate :created_at, :key, :text, :trackable, to: :activity

    alias activity item

    def actor
      @actor ||= display_name_for(activity.owner)
    end

    def display_name_for(user, possessive: false)
      UserPresenter
        .new(user, viewer, transfer)
        .display_name(possessive: possessive)
    end

    def transfer
      activity.trackable
    end
  end
end
