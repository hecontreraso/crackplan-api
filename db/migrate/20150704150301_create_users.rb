class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,              null: false
      t.string :password_digest,    null: false
      t.string :name,               null: false
      t.date :birthdate,            null: false
      t.string :gender,             null: false
      t.boolean :is_private,        null: false, default: false
      t.string :bio,                null: false, default: ""
      t.boolean :archived,          null: false, default: false
      t.string :auth_token
      t.string :image
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end