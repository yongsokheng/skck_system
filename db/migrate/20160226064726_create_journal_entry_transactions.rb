class CreateJournalEntryTransactions < ActiveRecord::Migration
  def change
    create_table :journal_entry_transactions do |t|
      t.string :description
      t.decimal :debit, precision: 15, scale: 2
      t.decimal :credit, precision: 15, scale: 2
      t.references :chart_of_account, index: true, foreign_key: true
      t.references :customer_vender, index: true, foreign_key: true
      t.references :journal_entry, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
