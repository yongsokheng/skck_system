class CreateSaleTaxCodes < ActiveRecord::Migration
  def change
    create_table :sale_tax_codes do |t|
      t.string :tax_code
      t.string :description
      t.boolean :taxable
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
