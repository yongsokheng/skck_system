class JournalEntriesController < ApplicationController
  load_and_authorize_resource
  before_action :load_data, only: [:new, :show]

  def new
  end

  def show
    @journal_entry = @current_company.journal_entries.find params[:id]
  end

  def create
    if @journal_entry.save
      flash[:success] = t "journal_entries.flashs.save_success"
      redirect_to root_path
    else
      load_data
      render "new"
    end
  end

  private
  def journal_entry_params
    params.require(:journal_entry).permit :user_id, :company_id, :transaction_date,
      journal_entry_transactions_attributes: [:id, :chart_of_account_id,
      :description, :debit, :credit, :customer_vender_id, :_destroy]
  end

  def load_data
    @current_company = current_user.company
    @chart_accounts = @current_company.chart_account_tree
    @customer_venders = @current_company.customer_venders.all
    10.times do
      @journal_entry.journal_entry_transactions.build
    end
  end
end
