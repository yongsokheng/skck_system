class JournalEntriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_current_compay
  before_action :load_data, only: [:index, :new]
  before_action :check_condition, only: :destroy

  def index
    @journal_entries = @current_company.journal_entries
      .includes(:journal_entry_transactions => :chart_of_account)
      .paginate(page: params[:page], per_page: 1)
      .order(transaction_date: :desc, id: :desc)
    @disabled = true
    @remote = true
  end

  def new
    9.times do
      @journal_entry.journal_entry_transactions.build
    end
    @disabled = false
    @remote = false
  end

  def create
    if @journal_entry.save
      flash[:success] = t "journal_entries.flashs.save_success"
    else
      flash[:alert] = t "journal_entries.flashs.save_not_success"
    end

    path = params[:commit] == Settings.commit_params.save_new ? new_journal_entry_path : journal_entries_path
    redirect_to path
  end

  def update
    if @journal_entry.update_attributes journal_entry_params
      flash.now[:success] = t "journal_entries.flashs.update_success"
    else
      flash.now[:alert] = t "journal_entries.flashs.update_not_success"
    end
  end

  def destroy
    @journal_entry.destroy
    flash[:success] = t "journal_entries.flashs.delete_success"
    redirect_to journal_entries_path
  end

  private
  def journal_entry_params
    params.require(:journal_entry).permit :user_id, :company_id, :transaction_date,
      :log_book_id, :bank_type_id, journal_entry_transactions_attributes: [:id, :chart_of_account_id,
      :description, :debit, :credit, :customer_vender_id, :_destroy]
  end

  def set_current_compay
    @current_company = current_user.company
  end

  def load_data
    @chart_accounts = @current_company.chart_of_accounts.find_data
      .map{|ca| [ca.chart_account_name, ca.id,
      {"data-type_code" => ca.chart_account_type.type_code},
      {"data-status" => ca.status}, {"data-type" => ca.chart_account_type.name}]}
    @customers = @current_company.customer_venders.customers.map{|data| [data.name, data.id,
      {"state" => data.state}, {"status" => data.status}]}
    @venders = @current_company.customer_venders.venders.map{|data| [data.name, data.id,
      {"state" => data.state}, {"status" => data.status}]}
    @bank_types = @current_company.bank_types.find_data.map{|type| [type.name, type.id,
      "data-cash_type" => type.cash_type_id]}
  end

  def check_condition
    if @journal_entry.log_book.open_balance?
      flash[:alert] = t "journal_entries.validate_errors.open_balance_validate"
      redirect_to new_journal_entry_path
    elsif !@current_company.working_period.current_period? @journal_entry.transaction_date
      flash[:alert] = t("journal_entries.validate_errors.wrong_period",
        period: "Current working period: #{@current_company.current_start_date_period} to #{@current_company.current_end_date_period}")
      redirect_to new_journal_entry_path
    end
  end
end
