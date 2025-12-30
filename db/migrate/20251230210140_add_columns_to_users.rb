class AddColumnsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :firstname,       :string,  null: false, default: ""
    add_column :users, :lastname,        :string,  null: false, default: ""
    add_column :users, :username,        :string,  null: false, default: ""
    add_column :users, :role,            :string,  null: false, default: "employee"
    add_column :users, :active,          :boolean, null: false, default: true
    add_column :users, :bio,             :text
    add_column :users, :github_username, :string
    add_column :users, :linkedin_url,    :string

    add_index :users, :username, unique: true
    add_index :users, :role
  end
end
