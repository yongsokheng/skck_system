class CreateEnterBillExpenses < ActiveRecord::Migration
  def change
    create_table :enter_bill_expenses do |t|
      t.float :amount
      t.string :memo
      t.references :chart_of_account, index: true, foreign_key: true
      t.references :enter_bill, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
