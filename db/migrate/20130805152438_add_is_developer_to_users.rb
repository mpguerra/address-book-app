class AddIsDeveloperToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_developer, :boolean
  end
end
