class AddDefaultParamToReview < ActiveRecord::Migration[5.0]
  def change
    
  change_column :reviews, :emotion, :integer, default: 2
  change_column :reviews, :review_caution, :boolean, :default => false

  end
end
