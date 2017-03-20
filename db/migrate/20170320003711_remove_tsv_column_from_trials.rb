class RemoveTsvColumnFromTrials < ActiveRecord::Migration
  def up
    remove_index :trials, :tsv
    remove_column :trials, :tsv, :tsvector

    execute <<-SQL
      DROP TRIGGER tsvectorupdate ON trials;
    SQL
  end

  def down
    add_column :trials, :tsv, :tsvector
    add_index :trials, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON trials FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', criteria, description, detailed_description, overall_contact_name, sponsor, title
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE trials SET updated_at = '#{now}'")
  end
end
