class User < ApplicationRecord
  validates :prof_name, presence: true, length: { maximum: 50 }
  #user - book
  has_many :reviews
  has_many :has_books, through: :reviews, source: :book
  
  #user - user #block未実装
  has_many :user_relations
  has_many :to_users, through: :user_relations, source: :to_user
  
  has_many :following_relations, -> { where(follow: true) }, class_name: 'UserRelation', foreign_key: 'user_id'
  has_many :followings, through: :following_relations, source: :to_user
  has_many :muting_relations, -> { where(mute: true) }, class_name: 'UserRelation', foreign_key: 'user_id'
  has_many :mutings, through: :muting_relations, source: :to_user
  
  has_many :follower_relations, -> { where(follow: true) }, class_name: 'UserRelation', foreign_key: 'to_user_id'
  has_many :followers, through: :follower_relations, source: :user
  
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
  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    auth_name = auth[:info][:name]
    auth_nickname = auth[:info][:name]
    image_url = auth[:info][:image].gsub('_normal', '')
    self.find_or_create_by(provider: provider, uid: uid) do |user|
      user.auth_name = auth_name
      user.auth_nickname = auth_nickname
      user.image_url = image_url
    end
  end
end
