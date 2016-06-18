class EnterBillsController < ApplicationController
  load_and_authorize_resource
  before_action :set_current_compay
  before_action :load_data, only: [:new]

  def new
    10.times do
      @enter_bill.enter_bill_expenses.build
      @enter_bill.enter_bill_items.build
    end
    @remote = false
  end

  private

  def set_current_compay
    @current_company = current_user.company
  end

  def load_data
    @venders = @current_company.customer_venders.venders.map{|data| [data.name, data.id,
      {"state" => data.state}, {"status" => data.status}]}
    @chart_accounts = @current_company.chart_of_accounts.find_data
      .map{|ca| [ca.chart_account_name, ca.id,
      {"data-type_code" => ca.chart_account_type.type_code},
      {"data-active" => ca.active}, {"data-type" => ca.chart_account_type.name}]}
    @item_lists = @current_company.item_lists.select_data
      .map{|data| [data.name, data.id, {"data-active" => data.active},
      {"data-type" => data.item_list_type_name}, {"data-um_id" => data.unit_of_measure_id},
      {"data-cost" => data.cost}]}
    @measures = @current_company.measures.find_measures
    @disabled = false
  end
end
