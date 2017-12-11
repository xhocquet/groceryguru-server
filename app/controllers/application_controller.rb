class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }
  before_action :authenticate_user!, if: lambda { |controller| controller.request.format.html? }, except: :index
  protect_from_forgery with: :exception

  default_form_builder AppFormBuilder
  layout 'application'

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    if @current_user
      @receipt = Receipt.new
    else
      render "intro", layout: "simple"
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || root_path
  end

  private

  def render_404
    render 'shared/404' and return
  end

  def validate_admin
    redirect_to new_user_session_url unless current_user.admin?
  end
end
