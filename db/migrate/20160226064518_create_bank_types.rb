class CreateBankTypes < ActiveRecord::Migration
  def change
    create_table :bank_types do |t|
      t.string :name
      t.string :account_code
      t.float :balance_total
      t.integer :status, default: 1
      t.references :cash_type, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
