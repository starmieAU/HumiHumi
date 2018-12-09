class ToppagesController < ApplicationController
  def index
    @microposts = Review.where(micropost_f: true).order(updated_at: "DESC").page(params[:page]).per(10)
    @tweet_data = get_tweet_data    
  end
  def what
  end
  def index_users
    if logged_in?
      @microposts = Review.where(micropost_f: true,user_id: current_user.followings + [current_user] - current_user.mutings ).order(updated_at: "DESC").page(params[:page]).per(10)
    else
      @microposts = Review.where(micropost_f: true).order(updated_at: "DESC").page(params[:page]).per(10)
    end
    @tweet_data = get_tweet_data
    render :index
  end
  
  private
  
  def get_tweet_data
    {
      card: "summary_large_image",
      title: "書籍レビューサイト【HumiHumi】",
      content: "次の本は何を読もうか？HumiHumiで「私の三冊」「10文字レビュー」等ユニークな機能を使ってみんなのレビューを見てみよう！",
      image_url: "/images/top_image.png"
    }
  end
  
end
