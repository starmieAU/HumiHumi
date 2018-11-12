class UserRelationsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    case params[:relation]
      when 'follow'
        current_user.follow(user)
        flash[:success] = 'ユーザをフォローしました。'
      when 'mute'
        current_user.mute(user)
        flash[:success] = 'ユーザをミュートしました。'
    end
    redirect_to user
  end

  def destroy
    user = User.find(params[:user_id])
    case params[:relation]
      when 'follow'
        current_user.unfollow(user)
        flash[:success] = 'ユーザのフォローを解除しました。'
      when 'mute'
        current_user.unmute(user)
        flash[:success] = 'ユーザのミュートを解除しました。'
    end
    redirect_to user
  end
end
