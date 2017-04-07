class CreateOrganizationConfigurations < ActiveRecord::Migration
  def change
    create_table :organization_configurations do |t|
    	t.text :conditions_filter
      t.timestamps null: false
    end
  end
end
