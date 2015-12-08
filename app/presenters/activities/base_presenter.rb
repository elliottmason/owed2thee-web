module Activities
  class BasePresenter < ::BasePresenter
    delegate :created_at, :key, :text, :trackable, to: :activity

    alias_method :activity, :item

    def actor
      @actor ||= display_name_for(activity.owner)
    end

    def display_name_for(user, possessive: false)
      UserPresenter
        .new(user, viewer, transfer)
        .display_name(possessive: possessive)
    end

    alias_method :transfer, :trackable
  end
end
