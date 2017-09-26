class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :health_check
  protect_from_forgery with: :exception

  default_form_builder AppFormBuilder

  layout 'application'

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @receipt = Receipt.new
  end

  def health_check
    head :ok
  end

  private

  def render_404
    render 'shared/404' and return
  end

  def validate_admin
    redirect_to new_user_session_url unless current_user.admin?
  end
end
