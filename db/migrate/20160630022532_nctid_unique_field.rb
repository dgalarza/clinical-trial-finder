class NctidUniqueField < ActiveRecord::Migration
  def change
    add_index :trials, :nct_id, unique: true
  end
end
