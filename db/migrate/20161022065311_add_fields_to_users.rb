class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :image, :string
    add_column :users, :name_first, :string
    add_column :users, :name_last, :string
    add_column :users, :access_token, :string
  end
end
