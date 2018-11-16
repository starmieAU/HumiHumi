class UsersController < ApplicationController
  before_action :user_find_count, only: [:show, :edit, :update, :followers, :followings, :shelves, :tweet]
  before_action :check, only: [:edit,:update, :tweet]
  def show
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
        flash[:success] = 'ユーザー情報が更新されました'
        redirect_to @user 
    else
        flash.now[:danger] = 'ユーザーが更新されませんでした'
        render :edit
    end
  end
  
  def index
    @users = nil
  end

  def shelves
    @shelves = @user.shelf_relations.order(updated_at: "DESC").page(params[:page]).per(10)
  end

  def followings
    @followings = @user.followings.page(params[:page]).per(20)
  end

  def followers
    @followers = @user.followers.page(params[:page]).per(20)
  end

  #tweet
  def tweet
    if logged_in?
      client = Twitter::REST::Client.new do |config|
        #applicationの設定
        config.consumer_key = ENV["TWITTER_KEY"]
        config.consumer_secret = ENV["TWITTER_SECRET"]
        #ユーザー情報の設定
        config.access_token         = current_user.token
        config.access_token_secret  = current_user.secret
      end
  
      #Twitter投稿
      client.update(params[:text])
      flash[:success] = 'ツイートしました'
    redirect_back(fallback_location: root_path)
    end
  end


  private
  
  def user_find_count
    @user = User.find(params[:id])
    counts(@user)
  end
  
  def check
    user_check(@user)
  end

  def user_params
    params.require(:user).permit(
    :prof_name,
    :prof_greeting,
    :first_login_f
    )
  end
end
