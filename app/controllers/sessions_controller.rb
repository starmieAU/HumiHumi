class SessionsController < ApplicationController
  def create
    
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    session[:user_id] = user.uid
    flash[:success] = "ユーザ認証が完了しました。"
    if user.first_login_f == false
      redirect_to edit_user_path(user)
    else
      redirect_to root_path
    end
  end

  def destroy
      reset_session
      flash[:success] = "ログアウトしました。"
      redirect_to root_path
  end
  
  def failure
    flash[:danger] = "ログインに失敗しました。"
    redirect_to root_url
  end
end
