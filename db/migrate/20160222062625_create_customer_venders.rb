class CreateCustomerVenders < ActiveRecord::Migration
  def change
    create_table :customer_venders do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :contact
      t.integer :status
      t.references :company, index: true, foreign_key: true
      t.float :balance_total

      t.timestamps null: false
    end
  end
end
