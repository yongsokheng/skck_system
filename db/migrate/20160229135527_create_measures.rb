class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|

      t.string :name
      t.string :abbreviation
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
