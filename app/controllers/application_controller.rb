class ApplicationController < ActionController::Base
  include Pundit

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  protect_from_forgery with: :exception
end
