class CreateChartOfAccounts < ActiveRecord::Migration
  def change
    create_table :chart_of_accounts do |t|
      t.string :account_no
      t.string :name
      t.string :description
      t.float :balance_total
      t.float :statement_ending_balance
      t.date :statement_ending_date
      t.integer :parent_id
      t.references :chart_account_type, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
