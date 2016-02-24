class JournalEntriesController < ApplicationController
  load_and_authorize_resource

  def new
    load_data
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
    @chart_accounts = current_user.company.chart_of_accounts
      .map{|c| [c.name_with_account_no, c.id, {"data-account-type-code" => c.chart_account_type.type_code}]}
    @customer_venders = current_user.company.customer_venders.all
    10.times do
      @journal_entry.journal_entry_transactions.build
    end
  end
end
