class CreateUserRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :user_relations do |t|
      t.references :user, foreign_key: true
      t.references :to_user, foreign_key: { to_table: :users }
      t.boolean :follow
      t.boolean :mute
      t.boolean :block
      t.timestamps
    end
  end
end
