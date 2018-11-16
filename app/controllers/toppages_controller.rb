class ToppagesController < ApplicationController
  def index
    if logged_in?
      @microposts = Review.where(micropost_f: true,user_id: current_user.followings + [current_user] - current_user
      .mutings ).order(updated_at: "DESC").page(params[:page]).per(10)
    else
      @microposts = Review.where(micropost_f: true).order(updated_at: "DESC").page(params[:page]).per(10)
    end
  end
  def what
  end
  def index_all
    @microposts = Review.where(micropost_f: true).order(updated_at: "DESC").page(params[:page]).per(10)
    render :index
  end
  
end
