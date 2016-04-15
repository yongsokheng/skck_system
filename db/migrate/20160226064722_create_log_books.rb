class CreateLogBooks < ActiveRecord::Migration
  def change
    create_table :log_books do |t|
      t.date :transaction_date
      t.string :reference_no
      t.boolean :open_balance, default: false
      t.integer :no
      t.references :cash_type, index: true, foreign_key: true
      t.references :voucher_type, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
