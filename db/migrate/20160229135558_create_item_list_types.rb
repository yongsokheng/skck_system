class CreateItemListTypes < ActiveRecord::Migration
  def change
    create_table :item_list_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
