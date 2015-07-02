class BaseCell < Cell::ViewModel
  include Pundit

  def show
    render
  end

  private

  def current_user
    options[:current_user]
  end
end
