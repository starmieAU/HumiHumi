class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :prof_name
      t.text :prof_greeting
      t.string :uid
      t.string :provider
      t.string :auth_name
      t.string :auth_nickname
      t.string :image_url

      t.timestamps
    end
  end
end
