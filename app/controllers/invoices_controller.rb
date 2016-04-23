class InvoicesController < ApplicationController
  load_and_authorize_resource
  before_action :set_current_compay
  before_action :load_data, only: [:index, :new]
  before_action :set_company, only: [:create]
  before_action :set_invoice_no, only: :new

  def new
    10.times do
      @invoice.invoice_transactions.build
    end
    @disabled = false
    @remote = false
  end

  def create
    if @invoice.save
      flash[:success] = t "create_invoice.flashs.save_success"
    else
      flash[:alert] = t "create_invoice.flashs.save_not_success"
    end

    path = params[:commit] == Settings.commit_params.save_new ? new_invoice_path : invoices_path
    redirect_to path
  end

  private
  def invoice_params
    params.require(:invoice).permit :invoice_no, :transaction_date, :customer_vender_id,
      :bill_to, :ship_to, :term_id, invoice_transactions_attributes: [:id, :item_list_id,
      :description, :quantity, :unit_of_measure_id, :price_each, :_destroy]
  end

  def set_current_compay
    @current_company = current_user.company
  end

  def set_company
    @invoice.company_id = @current_company.id
  end

  def load_data
    @item_lists = @current_company.item_lists.select_data
      .map{|data| [data.name, data.id, {"data-active" => data.active},
      {"data-type" => data.item_list_type_name}, {"data-um_id" => data.unit_of_measure_id},
      {"data-price" => data.price}]}
    @customers = @current_company.customer_venders.customers.map{|data| [data.name, data.id,
      {"state" => data.state}, {"status" => data.status}]}
    @measures = @current_company.measures.find_measures
    @terms = @current_company.terms.map{|term| [term.name, term.id]}
  end

  def set_invoice_no
    last_invoice = Invoice.order(invoice_no: :DESC).limit(1).last
    @invoice_no = last_invoice.present? ? last_invoice.invoice_no + 1 : 1
  end
end
