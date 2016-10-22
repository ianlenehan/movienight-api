class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :rating_score, :default => 0
      t.integer :user_id
      t.integer :event_id
      t.timestamps
    end
  end
end
