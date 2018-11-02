class UserRelation < ApplicationRecord
  belongs_to :user
  belongs_to :to_user, class_name: 'User'
  #scope :followed, -> { where(follow: true) }
end
