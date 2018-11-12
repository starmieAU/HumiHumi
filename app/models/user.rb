class User < ApplicationRecord
  #validates :prof_name, presence: true, length: { maximum: 50 }
  validate :add_error_sample
  
  def add_error_sample
    # auth_nameエラーメッセージ
    if prof_name.length == 0
      errors[:base] << "ユーザー名を入力してください。。"
    elsif prof_name.length > 50
      errors[:base] << "ユーザー名を50文字以内で入力してください。"
    end
  end
  
  #user - book
  has_many :reviews
  has_many :has_books, through: :reviews, source: :book
    #レビュー
  has_many :shelf_relations, -> { where(favorite: false) }, class_name: 'Review', foreign_key: 'user_id'
  has_many :shelf_books, through: :shelf_relations, source: :book
    #私の三冊
  has_many :favorite_relations, -> { where(favorite: true) }, class_name: 'Review', foreign_key: 'user_id'
  has_many :favorite_books, through: :favorite_relations, source: :book
    #microposts
  has_many :micropost_relations, -> { where(micropost_f: true) }, class_name: 'Review', foreign_key: 'user_id'

  #user - user #block未実装
  has_many :user_relations
  has_many :to_users, through: :user_relations, source: :to_user
  
  has_many :following_relations, -> { where(follow: true) }, class_name: 'UserRelation', foreign_key: 'user_id'
  has_many :followings, through: :following_relations, source: :to_user
  has_many :muting_relations, -> { where(mute: true) }, class_name: 'UserRelation', foreign_key: 'user_id'
  has_many :mutings, through: :muting_relations, source: :to_user
  
  has_many :follower_relations, -> { where(follow: true) }, class_name: 'UserRelation', foreign_key: 'to_user_id'
  has_many :followers, through: :follower_relations, source: :user
  
  def get_shelf(book)
    self.shelf_relations.find_by(book_id: book.id)
  end
  
  #shelf
  def shelf(book)
    self.shelf_relations.find_or_create_by(book_id: book.id)
  end

  def unshelf(book)
    shelf = self.shelf_relations.find_by(book_id: book.id)
    shelf.destroy if shelf
  end

  def shelf?(book)
    self.shelf_books.include?(book)
  end
  
  #favorite
  def favorite(book)
    self.favorite_relations.find_or_create_by(book_id: book.id)
  end

  def unfavorite(book)
    favorite = self.favorite_relations.find_by(book_id: book.id)
    favorite.destroy if favorite
  end

  def favorite?(book)
    self.favorite_books.include?(book)
  end
  
  def favoritedesided?
    self.favorite_books.count == 3
  end  
  
  #following
  def follow(other_user)
    unless self == other_user
      following_relation = self.user_relations.find_or_create_by(to_user_id: other_user.id)
      following_relation.update(follow: true)
    end
  end
  def unfollow(other_user)
    following_relation = self.user_relations.find_by(to_user_id: other_user.id)
    if following_relation
      following_relation.update(follow: false)
      following_relation.destroy unless (following_relation.follow || following_relation.mute || following_relation.block)
    end
  end
  def following?(other_user)
    self.followings.include?(other_user)
  end
  #muting
  def mute(other_user)
    unless self == other_user
      muting_relation = self.user_relations.find_or_create_by(to_user_id: other_user.id)
      muting_relation.update(mute: true)
    end
  end
  def unmute(other_user)
    muting_relation = self.user_relations.find_by(to_user_id: other_user.id)
    if muting_relation
      muting_relation.update(mute: false)
      muting_relation.destroy unless (muting_relation.follow || muting_relation.mute || muting_relation.block)
    end
  end
  def muting?(other_user)
    self.mutings.include?(other_user)
  end
  
  #auth認証
  def self.find_or_create_from_auth_hash(auth_hash)
    #OmniAuthで取得した各データを代入していく
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    auth_name = auth_hash[:info][:name]
    auth_nickname = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image].gsub('_normal', '')

    User.find_or_create_by(provider: provider, uid: uid) do |user|
      user.prof_name = auth_name
      user.auth_name = auth_name
      user.auth_nickname = auth_nickname
      user.image_url = image_url
    end
  end
  
end
