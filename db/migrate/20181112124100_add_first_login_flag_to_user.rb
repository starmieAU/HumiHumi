class AddFirstLoginFlagToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_login_f, :boolean, default: false

  end
end
