require "rails_helper"

describe "scheduler:import_trials_from_clinicaltrials_gov" do
  include_context "rake"

  before do
    allow(RestClient).to receive(:get)
  end

  it "imports from TrialsImporter" do
    with_environment "CLINICALTRIALS_SYNC_CRONITOR_ID" => "12345" do
      importer_spy = spy(:importer)
      allow(TrialsImporter).to receive(:new).and_return(importer_spy)

      subject.invoke

      expect(importer_spy).to have_received(:import)
    end
  end

  it "pings cronitor service" do
    cronitor_id = "12345"
    with_environment "CLINICALTRIALS_SYNC_CRONITOR_ID" => cronitor_id do
      allow_any_instance_of(TrialsImporter).to receive(:import)

      subject.invoke

      expect(RestClient).to have_received(:get).with(
        "https://cronitor.link/#{cronitor_id}/complete"
      )
    end
  end
end
