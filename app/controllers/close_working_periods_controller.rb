class CloseWorkingPeriodsController < ApplicationController

  def create
    @success = ActiveRecord::Base.transaction do
      begin
        company = current_user.company
        safe_log_book = LogBook.create_log_book CashType.types[:safe], company
        bank_log_book = LogBook.create_log_book CashType.types[:bank], company

        company.bank_types.each do |bank_type|
          total_balance = bank_type.total_open_balance

          log_book_id = bank_type.cash_type.id == CashType.types[:safe] ? safe_log_book.id : bank_log_book.id
          journal_entry = company.journal_entries.new transaction_date: company.working_period.new_period,
            log_book_id: log_book_id, bank_type_id: bank_type.id
          journal_entry.save! validate: false

          journal_entry.journal_entry_transactions.new(description: t("journal_entries.labels.open_balance"),
            debit: total_balance).save! validate: false
          journal_entry.journal_entry_transactions.new(description: t("journal_entries.labels.open_balance"),
            credit: total_balance).save! validate: false
        end
        company.working_period.update_period
        true
      rescue
        raise ActiveRecord::Rollback
        false
      end
    end

    if @success
      flash[:success] = t "journal_entries.flashs.close_period_success"
    else
      flash[:alert] = t "journal_entries.flashs.close_period_fail"
    end
    redirect_to root_path
  end
end
