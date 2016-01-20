module Users
  class BaseController < ApplicationController
    before_action :authenticate_user!
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped
  end
end
