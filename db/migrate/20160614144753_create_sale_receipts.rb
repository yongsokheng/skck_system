class CreateSaleReceipts < ActiveRecord::Migration
  def change
    create_table :sale_receipts do |t|
      t.date :transaction_date
      t.string :bill_to
      t.string :ship_to
      t.integer :invoice_no
      t.string :po_number
      t.references :customer_vender, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true
      t.references :chart_of_account, index: true, foreign_key: true
      t.references :bank_type, index: true, foreign_key: true
      t.references :log_book, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
