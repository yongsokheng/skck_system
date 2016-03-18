class CloseWorkingPeriodsController < ApplicationController

  def create
    @success = ActiveRecord::Base.transaction do
      begin
        company = current_user.company

        company.bank_types.each do |bank_type|
          log_book = LogBook.create_or_find bank_type.cash_type, company

          total_balance = bank_type.total_open_balance

          journal_entry = company.journal_entries.new transaction_date: company.working_period.new_period,
            log_book_id: log_book.id, bank_type_id: bank_type.id
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
