class AddOriginalAgeToTrial < ActiveRecord::Migration
  def change
    add_column :trials, :minimum_age_original, :string
    add_column :trials, :maximum_age_original, :string
  end
end
