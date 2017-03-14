require "zip_code_seeder"

namespace :database do
  desc "Clears all import data"
  task clear_import_data: :environment do
    puts "Starting to clear data"
    Site.delete_all(id: Site.pluck(:id))
    Trial.delete_all(id: Trial.pluck(:id))
    ImportLog.delete_all(id: ImportLog.delete_all)
    puts "Data clear complete"
  end

  desc "Seed zip code data"
  task seed_zip_codes: :environment do
    ZipCodeSeeder.run
  end
end
