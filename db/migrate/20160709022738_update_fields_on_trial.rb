class UpdateFieldsOnTrial < ActiveRecord::Migration
  def change
    remove_column :trials, :focus, :string
    remove_column :trials, :condition, :string
    add_column :trials, :conditions, :string, array: true, default: []
    add_column :trials, :criteria, :text
    remove_column :trials, :inclusion, :text
    remove_column :trials, :exclusion, :text
    remove_column :trials, :country, :string
    add_column :trials, :countries, :string, array: true, default: []
    add_column :trials, :overall_contact_phone, :string
    add_column :trials, :overall_contact_email, :string
    add_column :trials, :link_url, :string
    add_column :trials, :link_description, :string
    add_column :trials, :first_received_date, :string
    add_column :trials, :last_changed_date, :string
    add_column :trials, :verification_date, :string
    add_column :trials, :keywords, :string, array: true, default: []
    add_column :trials, :is_fda_regulated, :string
    add_column :trials, :has_expanded_access, :string
  end
end
