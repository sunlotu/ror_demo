class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_salt
      t.string :password_digest
      t.string :token
      t.string :remember_digest

      t.timestamps
    end
  end
end
