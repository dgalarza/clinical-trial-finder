class ChangeDateFieldsOnTrials < ActiveRecord::Migration
  def change
    change_column :trials, :first_received_date, "date using first_received_date::date"
    change_column :trials, :last_changed_date, "date using last_changed_date::date"
  end
end
