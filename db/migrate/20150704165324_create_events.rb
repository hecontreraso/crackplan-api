class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string  :details,           null: false
      t.string  :where,             null: false
      t.date    :date,              null: false
      t.time    :time,              null: true
      t.string  :image,             null: true
      t.integer :creator_id,        null: false
      t.boolean :archived,          null: false, default: false
      t.timestamps
    end
  end
end
