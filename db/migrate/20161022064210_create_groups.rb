class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :group_name
      t.text :image, :default => 'https://bit.ly/2eRyG7R'
      t.integer :group_admin
      t.timestamps
    end
  end
end
