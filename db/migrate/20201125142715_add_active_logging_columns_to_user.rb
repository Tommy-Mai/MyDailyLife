class AddActiveLoggingColumnsToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :last_login_at, :datetime, :default => nil
    add_column :users, :last_logout_at, :datetime, :default => nil
    add_column :users, :login_count, :integer, :default => 0
  end

  def down
    remove_column :users, :last_login_at
    remove_column :users, :last_logout_at
    remove_column :users, :login_count
  end
end
