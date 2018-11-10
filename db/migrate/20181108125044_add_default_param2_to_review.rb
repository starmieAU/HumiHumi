class AddDefaultParam2ToReview < ActiveRecord::Migration[5.0]
  def change
    
  change_column :reviews, :u_article, :string, default: ''
  change_column :reviews, :review_10_char, :string, default: ''
    
  end
end
