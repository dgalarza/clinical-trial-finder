if Rails.env.development? || Rails.env.test?
  require "factory_girl"

  namespace :dev do
    desc "Seed data for local development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods

      TrialsImporter.new.import
    end
  end
end
