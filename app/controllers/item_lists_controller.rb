class ItemListsController < ApplicationController
  load_and_authorize_resource
  before_action :select_data, only: [:new, :edit, :create]

  def index
    @item_lists = ItemList.roots
  end

  def new
  end

  def create
    @item_list = @company.item_lists.new item_list_params
    if @item_list.save
      flash[:notice] = t "flashs.messages.created"
      redirect_to item_lists_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item_list.update_attributes item_list_params
      flash[:notice] = t "flashs.messages.updated"
      redirect_to item_lists_path
    else
      render :edit
    end
  end

  def destroy
    @item_list.destroy
    flash[:notice] = t "flashs.messages.deleted"
    redirect_to item_lists_path
  end

  private
  def select_data
    @types = ItemListType.all
    @company = current_user.company
    @chart_accounts = @company.chart_account_tree
    @customer_venders = @company.customer_venders
    @measures = Measure.all
  end

  def item_list_params
    params.require(:item_list).permit :item_list_type_id, :name, :description,
      :chart_of_account_id, :parent_id, :manufacturer_part_number, :customer_vender_id,
      :unit_of_measure_id, :cost, :purchase_description, :price, :sale_description
  end
end
