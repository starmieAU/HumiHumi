class AddDefaultParam4ToReview < ActiveRecord::Migration[5.0]
  def change
  change_column :reviews, :point, :integer, default: 0
  change_column :reviews, :u_point, :integer, default: 0
  end
end
