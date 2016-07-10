class AddZipCodes < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.string :zip_code
      t.float :latitude
      t.float :longitude
    end
  end
end
