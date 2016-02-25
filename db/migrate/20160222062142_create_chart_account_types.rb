class CreateChartAccountTypes < ActiveRecord::Migration
  def change
    create_table :chart_account_types do |t|
      t.string :name
      t.string :type_code
      t.timestamps null: false
    end
  end
end
