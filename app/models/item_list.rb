class ItemList < ActiveRecord::Base
  has_closure_tree

  belongs_to :chart_of_account
  belongs_to :company
  belongs_to :customer_vender
  belongs_to :item_list_type
  belongs_to :unit_of_measure

  validates :name, presence: true, length: {maximum: 255}
  validate :name_existed


  delegate :name, :id, to: :item_list_type, prefix: true, allow_nil: true
  delegate :name, to: :chart_of_account, prefix: true, allow_nil: true
  delegate :name, :id, to: :customer_vender, prefix: true, allow_nil: true

  class << self
    def item_list_tree item_arr=[], item_lists
      item_lists.each do |item|
        item_arr << {id: item.id, text: item.name, depth: item.depth, type: item.item_list_type.name}
        item.children.each do |child|
          item_arr << {id: child.id, text: child.name, depth: child.depth, type: child.item_list_type.name}
          item_list_tree item_arr, child.children
        end
      end
      item_arr
    end
  end

  private
  def name_existed
    if parent_id.present?
      children_name = ItemList.find(parent_id).children.where.not(id: id).map(&:name)
    else
      children_name = ItemList.roots.where.not(id: id).map(&:name)
    end
    errors.add :name, I18n.t("chart_of_accounts.messages.existed") if
      children_name.map(&:downcase).include? name.downcase
  end
end
