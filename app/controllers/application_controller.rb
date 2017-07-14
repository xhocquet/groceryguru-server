class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  def index
    @receipt = current_user.receipts.build
  end
end
