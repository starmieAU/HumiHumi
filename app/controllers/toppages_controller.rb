class ToppagesController < ApplicationController
  def index
    @microposts = Review.where(micropost_f: true).order(updated_at: "DESC").page(params[:page]).per(10)
  end
  def what
  end
  def index_users
    if logged_in?
      @microposts = Review.where(micropost_f: true,user_id: current_user.followings + [current_user] - current_user.mutings ).order(updated_at: "DESC").page(params[:page]).per(10)
    else
      @microposts = Review.where(micropost_f: true).order(updated_at: "DESC").page(params[:page]).per(10)
    end
    render :index
  end
  
end
