module ApplicationHelper
  def page_title
    [t('app.title'), (yield(:title) if content_for(:title))].compact.join(' - ')
  end

  def render_activity(activity)
    partial_path = ->(a) { 'public_activity/' + a.key.tr('.', '/') }

    render(partial: partial_path.call(activity), locals: { activity: activity })
  end
end
