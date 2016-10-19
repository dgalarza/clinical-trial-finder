namespace :scheduler do
  desc "Import all trials from clinicaltrials.gov"
  task :import_trials_from_clinicaltrials_gov => :environment do
    TrialsImporter.new.import
    RestClient.get(cronitor_url)
  end

  def cronitor_url
    "https://cronitor.link/#{ENV.fetch("CLINICALTRIALS_SYNC_CRONITOR_ID")}/complete"
  end
end
