class Book < ApplicationRecord
  has_many :reviews
  has_many :has_users, through: :reviews, source: :user
end
