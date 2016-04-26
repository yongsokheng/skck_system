class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.date :transaction_date
      t.string :bill_to
      t.string :ship_to
      t.integer :invoice_no
      t.string :po_number
      t.references :term, index: true, foreign_key: true
      t.references :customer_vender, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
