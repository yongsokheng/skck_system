class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :name
      t.date :net_due
      t.float :discount
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
