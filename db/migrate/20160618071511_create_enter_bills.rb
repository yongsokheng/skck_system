class CreateEnterBills < ActiveRecord::Migration
  def change
    create_table :enter_bills do |t|
      t.date :transaction_date
      t.string :address
      t.string :memo
      t.references :customer_vender, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
