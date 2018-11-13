module UsersHelper
  def tweet_str(review)
    "#{review.user.prof_name}さんの10文字レビュー\n\n【#{review.review_10_char}】\n#{review.book.title}\n#{request.url}"
  end
end
