class User < ApplicationRecord
  validates :prof_name, presence: true, length: { maximum: 50 }
  
  has_many :reviews
  has_many :has_books, through: :reviews, source: :book
  
  
  has_many :user_relations
  has_many :to_users, through: :user_relations, source: :to_user
  
  has_many :following_relations, -> { where(follow: true) }, class_name: 'UserRelation', foreign_key: 'user_id'
  has_many :followings, through: :following_relations, source: :to_user
  has_many :muting_relations, -> { where(mute: true) }, class_name: 'UserRelation', foreign_key: 'user_id'
  has_many :mutings, through: :muting_relations, source: :to_user

  has_many :follower_relations, -> { where(follow: true) }, class_name: 'UserRelation', foreign_key: 'to_user_id'
  has_many :followers, through: :follower_relations, source: :user
  
  def follow(other_user)
    unless self == other_user
      follow_action = self.user_relations.find_or_create_by(to_user_id: other_user.id)
      follow_action.update(follow: true)
    end
  end
  
  
  
  
  #auth認証
  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    auth_name = auth[:info][:name]
    auth_nickname = auth[:info][:name]
    image_url = auth[:info][:image]
    self.find_or_create_by(provider: provider, uid: uid) do |user|
      user.auth_name = auth_name
      user.auth_nickname = auth_nickname
      user.image_url = image_url
    end
  end
end
