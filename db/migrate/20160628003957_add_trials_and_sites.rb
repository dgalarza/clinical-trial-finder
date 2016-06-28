class AddTrialsAndSites < ActiveRecord::Migration
  def change
    create_table :trials do |t|
      t.string :title
      t.text :description
      t.string :sponsor
      t.string :country
      t.string :focus
      t.string :nct_id
      t.string :official_title
      t.string :agency_class
      t.text :detailed_description
      t.string :overall_status
      t.string :phase
      t.string :study_type
      t.string :condition
      t.string :inclusion
      t.string :exclusion
      t.string :gender
      t.integer :minimum_age, null: false, default: 0
      t.integer :maximum_age, null: false, default: 120
      t.string :healthy_volunteers
      t.string :overall_contact_name

      t.timestamps
    end

    create_table :sites do |t|
      t.belongs_to :trial, index: true, foreign_key: true
      t.text :facility
      t.text :street_address
      t.text :street_address2
      t.text :city
      t.text :state
      t.text :country
      t.text :zip_code

      t.timestamps
    end
  end
end
