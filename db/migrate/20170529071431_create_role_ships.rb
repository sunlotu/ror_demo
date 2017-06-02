class CreateRoleShips < ActiveRecord::Migration[5.0]
  def change
    create_table :role_ships do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
    add_index :role_ships, [:user_id, :role_id], unique: true
  end
end
