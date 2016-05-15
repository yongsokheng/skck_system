class CreateReceivePayments < ActiveRecord::Migration
  def change
    create_table :receive_payments do |t|
      t.date :transaction_date
      t.references :company, index: true, foreign_key: true
      t.references :customer_vender, index: true, foreign_key: true
      t.references :chart_of_account, index: true, foreign_key: true
      t.references :bank_type, index: true, foreign_key: true
      t.references :log_book, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
