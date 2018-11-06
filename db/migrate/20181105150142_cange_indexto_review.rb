class CangeIndextoReview < ActiveRecord::Migration[5.0]
  def change
    remove_index :reviews, [:user_id, :book_id]
    remove_index :reviews, [:user_id, :favorite]
    add_index :reviews, [:user_id, :book_id, :favorite], unique: true
  end
end
