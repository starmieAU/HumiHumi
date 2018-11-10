class AddDefaultParam3ToReview < ActiveRecord::Migration[5.0]
  def change
    
  change_column :reviews, :emotion, :integer, default: 2, null: false, limit: 1
  change_column :reviews, :read_status, :integer, default: 0, null: false, limit: 1
  
  end
end
