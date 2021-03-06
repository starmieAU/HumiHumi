class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :authenticate,:user_check

  private
  def user_check(user)
    unless current_user == user
      flash[:danger] = 'ユーザー情報が正しくありません'
      redirect_to root_path
    end
  end
  
  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by(uid: session[:user_id])
  end

  def logged_in?
    !!session[:user_id]
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: "ログインしてください"
  end
  
  def counts(user)
    @count_microposts = user.micropost_relations.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
  end
  
  def read(result)
    uid = nil
    title = result['title']
    subtitle = result['subTitle']
    authors = result['author']
    publisher = result['publisherName']
    published_date = result['salesDate']
    description = result['itemCaption']
    image_url = result['mediumImageUrl']&.gsub('?_ex=120x120', '') || "/images/no_image.png"
    isbn_10 = nil
    isbn_13 = result['isbn']
    {
      uid: uid,
      title: title,
      subtitle: subtitle,
      authors: authors,
      publisher: publisher,
      published_date: published_date,
      description: description,
      image_url: image_url,
      isbn_10: isbn_10,
      isbn_13: isbn_13,
    }
  end
end
