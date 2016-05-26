class ReceivePaymentsController < ApplicationController
  load_and_authorize_resource
  before_action :load_company
  before_action :set_company, only: [:create]
  before_action :load_data, only: [:index, :new]

  def index
    @receive_payments = @current_company.receive_payments.paginate(page: params[:page], per_page: 1)
    @remote = true
  end

  def new
    @customer_id = params[:customer_id]
    @transaction_date = params[:transaction_date]
    @chart_account = params[:chart_account]
    @bank_type = params[:bank_type]
    @log_book = params[:log_book]
    @invoices = Invoice.unpaid_invoices @customer_id.to_i
  end

  def create
    if @receive_payment.save
      flash[:success] = t "receive_payments.flashes.save_success"
    else
      flash[:alert] = t "receive_payments.flashes.save_not_success"
    end
    path = params[:commit] == Settings.commit_params.save_new ? new_receive_payment_path : receive_payments_path
    redirect_to path
  end

  def update
    if @receive_payment.update_attributes receive_payment_params
      flash.now[:success] = t "receive_payments.flashs.update_success"
    else
      flash.now[:alert] = t "receive_payments.flashs.update_not_success"
    end
  end

  def destroy
    @receive_payment.destroy
    flash[:success] = t "receive_payments.flashs.delete_success"
    redirect_to receive_payments_path
  end

  private
  def load_company
    @current_company = current_user.company
  end

  def load_data
    @customers = @current_company.customer_venders.customers.map{|data| [data.name, data.id]}
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
  end

  def receive_payment_params
    params.require(:receive_payment).permit :customer_vender_id, :transaction_date,
      :chart_of_account_id, :bank_type_id, :log_book_id,
      receive_payment_transactions_attributes: [:id, :invoice_id, :payment]
  end

  def set_company
    @receive_payment.company_id = @current_company.id
  end
end
