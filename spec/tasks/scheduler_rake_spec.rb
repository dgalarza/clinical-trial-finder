require "rails_helper"

describe "scheduler:import_trials_from_clinicaltrials_gov" do
  include_context "rake"

  it "imports from TrialsImporter" do
    importer_spy = spy(:importer)
    allow(TrialsImporter).to receive(:new).and_return(importer_spy)

    subject.invoke

    expect(importer_spy).to have_received(:import)
  end
end
