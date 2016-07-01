namespace :scheduler do
  desc "Import all trials from clinicaltrials.gov"
  task :import_trials_from_clinicaltrials_gov => :environment do
    TrialsImporter.new.import
  end
end
