class AddCountsToImportLog < ActiveRecord::Migration
  def change
    add_column :import_logs, :site_count, :integer
    add_column :import_logs, :trial_count, :integer
  end
end
