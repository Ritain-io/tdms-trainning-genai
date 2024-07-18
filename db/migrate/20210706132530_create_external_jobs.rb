class CreateExternalJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :external_jobs do |t|
      t.string :job_name
      t.string :cron
      t.datetime :last_run
      t.references :environment, null: false
    end
  end
end
