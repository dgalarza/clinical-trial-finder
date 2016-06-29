class AddAndRemoveFieldsToSite < ActiveRecord::Migration
  def change
    add_column :sites, :status, :string
    add_column :sites, :contact_name, :string
    add_column :sites, :contact_phone, :string
    add_column :sites, :contact_phone_ext, :string
    add_column :sites, :contact_email, :string

    remove_column :sites, :street_address
    remove_column :sites, :street_address2

    change_column_null :sites, :trial_id, false
  end
end
