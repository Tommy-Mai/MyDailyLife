class AddLastactivityatAndLoggedinToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :last_activity_at, :datetime, :default => nil
    add_column :users, :logged_in, :boolean, default: false
  end

  def down
    remove_column :users, :last_activity_at, :datetime, :default => nil
    remove_column :users, :logged_in, :boolean, default: false
  end
end
