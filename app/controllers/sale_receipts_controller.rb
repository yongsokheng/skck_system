class SaleReceiptsController < ApplicationController
  load_and_authorize_resource
  before_action :set_current_compay
  before_action :load_data, only: [:index, :new, :update]
  before_action :set_company, only: [:create]
  before_action :check_condition, only: :destroy

  def index
    @sale_receipts = @current_company.sale_receipts.paginate(page: params[:page], per_page: 1)
    @remote = true
  end

  def new
    10.times do
      @sale_receipt.sale_receipt_transactions.build
    end
    @remote = false
  end

  def create
    if @sale_receipt.save
      flash[:success] = t "sale_receipt.flashs.save_success"
    else
      byebug
      flash[:alert] = t "sale_receipt.flashs.save_not_success"
    end

    path = params[:commit] == Settings.commit_params.save_new ? new_sale_receipt_path : sale_receipt_path
    redirect_to path
  end

  def update
    if @sale_receipt.update_attributes sale_receipt_params
      flash.now[:success] = t "sale_receipt.flashs.update_success"
    else
      flash.now[:alert] = t "sale_receipt.flashs.update_not_success"
    end
    @remote = true
  end

  def destroy
    @sale_receipt.destroy
    flash[:success] = t "sale_receipt.flashs.delete_success"
    redirect_to sale_receipts_path
  end

  private
  def sale_receipt_params
    params.require(:sale_receipt).permit :invoice_no, :transaction_date, :customer_vender_id,
      :bill_to, :ship_to, :company_id, :chart_of_account_id, :bank_type_id,
      :log_book_id, sale_receipt_transactions_attributes: [:id, :item_list_id,
      :description, :quantity, :unit_of_measure_id, :price_each, :_destroy]
  end

  def set_current_compay
    @current_company = current_user.company
  end

  def set_company
    @sale_receipt.company_id = @current_company.id
  end

  def load_data
    @item_lists = @current_company.item_lists.select_data
      .map{|data| [data.name, data.id, {"data-active" => data.active},
      {"data-type" => data.item_list_type_name}, {"data-um_id" => data.unit_of_measure_id},
      {"data-price" => data.price}]}
    @customers = @current_company.customer_venders.customers.map{|data| [data.name, data.id,
      {"state" => data.state}, {"status" => data.status}]}
    @measures = @current_company.measures.find_measures
    @chart_accounts = @current_company.chart_of_accounts.includes(:chart_account_type)
      .map{|data| [data.name, data.id, {"data-active" => data.active},
      {"data-type" => data.chart_account_type.name}]}

    @bank_types = @current_company.bank_types.map{|bank_type| [bank_type.name,
      bank_type.id, {"data-cash_type" => bank_type.cash_type_id}]}

    voucher_type = VoucherType.types[:civ]
    start_date = @current_company.working_period.start_date
    end_date = @current_company.working_period.end_date
    @log_books = @current_company.log_books.find_by_voucher_type(voucher_type, start_date, end_date)
      .map{|data| [data.reference_no, data.id]}

    @disabled = false
  end

  def check_condition
    unless @current_company.working_period.current_period? @sale_receipt.transaction_date
      flash[:alert] = t "sale_receipt.validate_errors.wrong_period"
      redirect_to new_sale_receipt_path
    end
  end
end
