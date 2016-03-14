class JournalEntriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_current_compay
  before_action :load_data, only: [:new, :select_journal]

  def new
    log_books = @current_company.log_books.find_reference_by(Date.today, BankType.first.cash_type.id)
    @log_books = log_books.map{|logbook| [logbook.reference_no, logbook.id, "open-balance" => logbook.open_balance]}
    journal_entry = log_books.present? ? JournalEntry.find_by(log_book_id: log_books.first.id) : nil
    if journal_entry.present?
      @journal_entry = journal_entry
      @journal_entry.journal_entry_transactions.build
    else
      @journal_entry = JournalEntry.new
      10.times do
        @journal_entry.journal_entry_transactions.build
      end
    end
  end

  def create
    if @journal_entry.save
      flash[:success] = t "journal_entries.flashs.save_success"
    else
      flash[:alert] = t "journal_entries.flashs.save_not_success"
    end
    redirect_to root_path
  end

  def update
    if @journal_entry.update_attributes journal_entry_params
      flash[:success] = t "journal_entries.flashs.update_success"
    else
      flash[:alert] = t "journal_entries.flashs.update_not_success"
    end
    redirect_to root_path
  end

  def select_journal
    @journal_entry = JournalEntry.find params[:journal_entry_id]
    @log_books = @current_company.log_books.find_reference_by(params[:transaction_date], params[:cash_type_id])
      .map{|logbook| [logbook.reference_no, logbook.id, "open-balance" => logbook.open_balance]}
    @journal_entry.journal_entry_transactions.build
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
    @chart_accounts = @current_company.chart_account_tree
    @customer_venders = @current_company.customer_venders.all
    @bank_types = @current_company.bank_types.map{|type| [type.name, type.id,
      {"data-cash-type-id" => type.cash_type.id}]}
  end
end
