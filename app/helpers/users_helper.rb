module UsersHelper
  def tweet_str(review)
    if review.review_10_char.present?
      str = "#{review.user.prof_name}さんの10文字レビュー"
    else
       str ="#{review.user.prof_name}さんレビューページ"
    end
    str += "\n\n#{review.book.title} (#{review.book.authors})" + star(review) + "\n\n#humihumi\n#{request.url}"
  end
  
  def star(review)
    str = ""
    if review.point != 0
      str += "\n評価："
      review.point.times do
        str += "☆"
      end
    end
    if review.u_article != ""
      str += "\n#{review.u_article}："
      review.u_point.times do
        str += "☆"
      end
    end
    str
  end
end
