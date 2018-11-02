class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :uid
      t.string :title 
      t.string :subtitle
      t.string :authors
      t.string :publisher
      t.string :published_date
      t.string :description
      t.string :image_url
      t.string :isbn_10
      t.string :isbn_13

      t.timestamps
    end
  end
end
