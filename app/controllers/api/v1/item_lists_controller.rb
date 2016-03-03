module Api
  module V1
    class ItemListsController < Api::BaseController
      def index
        company_id = current_user.company.id
        roots = ItemList.roots.where(company_id: company_id, item_list_type: params[:item_list_type_id])
        item_list_tree = ItemList.item_list_tree(roots)
        respond_with item_list_tree
      end
    end
  end
end
