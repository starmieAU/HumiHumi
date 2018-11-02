class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.boolean :favorite, default: false, null: false
      t.integer :read_status
      t.integer :emotion
      t.integer :point
      t.string :u_article
      t.integer :u_point
      t.string :review_10_char
      t.text :review_text
      t.boolean :review_caution
      t.text :user_memo

      t.timestamps
      
      t.index [:user_id, :book_id], unique: true
      t.index [:user_id, :favorite]
    end
  end
end
