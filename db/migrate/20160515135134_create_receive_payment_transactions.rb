class CreateReceivePaymentTransactions < ActiveRecord::Migration
  def change
    create_table :receive_payment_transactions do |t|
      t.decimal :payment, precision: 15, scale: 2, default: 0
      t.references :receive_payment, index: true, foreign_key: true
      t.references :invoice, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
