class AddUsernameOrgNameToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :username, :string
  	add_column :users, :org_name, :string
  end
end
