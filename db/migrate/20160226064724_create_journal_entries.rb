class CreateJournalEntries < ActiveRecord::Migration
  def change
    create_table :journal_entries do |t|
      t.date :transaction_date
      t.references :user, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true
      t.references :log_book, index: true, foreign_key: true
      t.references :bank_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
