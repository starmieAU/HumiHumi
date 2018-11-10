class Review < ApplicationRecord
  #validates :u_article, length: { maximum: 10 }
  #validates :review_10_char, length: { maximum: 10 }
  validate :add_error_sample
  enum emotion:{like:1,non:2,hate:3}, _prefix: :emotion
  enum read_status:{non:0,ing:1,done:2,ed:3,will:4}, _prefix: :read
 
  def add_error_sample
    # nameが空のときにエラーメッセージを追加する
    if (u_article.present? && u_article.length > 10)
      errors[:base] << "オリジナル基準:10文字を超えています"
    end
 
    # 価格が空のときにエラーメッセージを追加する
    if (review_10_char.present? && review_10_char.length > 10)
      errors[:base] << "10文字評価:10文字を超えています"
    end
  end
  
  belongs_to :user
  belongs_to :book
end
