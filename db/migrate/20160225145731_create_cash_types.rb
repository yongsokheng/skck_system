class CreateCashTypes < ActiveRecord::Migration
  def change
    create_table :cash_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
