class RobotsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def show
    respond_to :text
    expires_in 1.day, public: true
  end
end
