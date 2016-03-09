class CreateWorkingPeriods < ActiveRecord::Migration
  def change
    create_table :working_periods do |t|
      t.date :start_date
      t.date :end_date
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
