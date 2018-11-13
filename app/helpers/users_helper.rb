module UsersHelper
  def tweet_str(review)
    if review.review_10_char.present?
      "#{review.user.prof_name}さんの10文字レビュー\n\n【#{review.review_10_char}】\n#{review.book.title}\n#{request.url}"
    else
      "#{review.user.prof_name}さんレビューページ\n#{review.book.title}\n\n#{request.url}"
    end
  end
end
