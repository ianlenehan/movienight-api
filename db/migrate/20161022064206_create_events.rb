class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.text :location
      t.text :imdb_id
      t.datetime :date
      t.integer :group_id
      t.timestamps
    end
  end
end
