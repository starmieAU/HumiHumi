class AddMicropostfToReview < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :micropost_f, :boolean, default: false

  end
end
