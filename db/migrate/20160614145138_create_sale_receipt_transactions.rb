class CreateSaleReceiptTransactions < ActiveRecord::Migration
  def change
    create_table :sale_receipt_transactions do |t|
      t.string :description
      t.float :quantity
      t.decimal :price_each, precision: 15, scale: 2
      t.references :sale_receipt, index: true, foreign_key: true
      t.references :item_list, index: true, foreign_key: true
      t.references :sale_tax_code, index: true, foreign_key: true
      t.references :unit_of_measure, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
