class CreateChartOfAccountHierarchies < ActiveRecord::Migration
  def change
    create_table :chart_of_account_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :chart_of_account_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "chart_of_account_anc_desc_idx"

    add_index :chart_of_account_hierarchies, [:descendant_id],
      name: "chart_of_account_desc_idx"
  end
end
