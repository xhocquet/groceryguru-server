class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in @user
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end
