class SessionsController < ApplicationController
  def create
    
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    session[:user_id] = user.uid
    flash[:success] = "ユーザ認証が完了しました。"
    redirect_to root_path
  end

  def destroy
      reset_session
      flash[:success] = "ログアウトしました。"
      redirect_to root_path
  end
  
  def failure
    redirect_to root_url, alert: "Authentication failed."
  end
end
