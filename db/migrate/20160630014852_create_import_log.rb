class CreateImportLog < ActiveRecord::Migration
  def change
    create_table :import_logs do |t|
      t.timestamps
    end
  end
end
