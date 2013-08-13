class Add3scaleAccountIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :developer_account_id, "bigint"
    add_index :users, :developer_account_id
  end
end
