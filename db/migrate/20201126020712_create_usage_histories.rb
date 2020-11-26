class CreateUsageHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :usage_histories do |t|
      t.integer :user_id, null: false
      t.datetime :login_at, :default => nil
      t.datetime :logout_at, :default => nil
      t.string :utilization_time, :default => nil
      t.datetime :last_activity_at, :default => nil
      t.boolean :timeout, default: false
      t.datetime :timeout_time, :default => nil
      t.integer :action_count, default: 0
      t.integer :mealtask_create_count, default: 0
      t.integer :othertask_create_count, default: 0
      t.integer :tag_create_count, default: 0
      t.integer :comment_create_count, default: 0
      t.integer :memo_create_count, default: 0
    end
  end
end
