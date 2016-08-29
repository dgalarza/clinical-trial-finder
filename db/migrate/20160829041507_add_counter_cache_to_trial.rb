class AddCounterCacheToTrial < ActiveRecord::Migration
  def change
    add_column :trials, :sites_count, :integer
  end
end
