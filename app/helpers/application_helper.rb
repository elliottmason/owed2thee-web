module ApplicationHelper
  def render_activity(activity)
    partial_path = ->(a) { 'public_activity/' + a.key.tr('.', '/') }

    render(partial: partial_path.call(activity), locals: { activity: activity })
  end
end
