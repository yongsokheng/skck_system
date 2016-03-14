class CreateItemListHierarchies < ActiveRecord::Migration
  def change
    create_table :item_list_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :item_list_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "item_list_anc_desc_idx"

    add_index :item_list_hierarchies, [:descendant_id],
      name: "item_list_desc_idx"
  end
end
