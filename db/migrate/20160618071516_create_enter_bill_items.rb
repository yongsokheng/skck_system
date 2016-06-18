class CreateEnterBillItems < ActiveRecord::Migration
  def change
    create_table :enter_bill_items do |t|
      t.string :description
      t.float :quantity
      t.decimal :cost
      t.references :unit_of_measure, index: true, foreign_key: true
      t.references :item_list, index: true, foreign_key: true
      t.references :enter_bill, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
