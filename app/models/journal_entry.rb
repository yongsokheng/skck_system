class JournalEntry < ActiveRecord::Base
  has_many :journal_entry_transactions, as: :journal, dependent: :destroy

  belongs_to :user
  belongs_to :company
  belongs_to :log_book
  belongs_to :bank_type

  accepts_nested_attributes_for :journal_entry_transactions,
    reject_if: proc {|attributes| attributes[:debit].blank? && attributes[:credit].blank?},
    allow_destroy: true

  validates :transaction_date, presence: true
  validates :log_book_id, presence: true
  validates :bank_type_id, presence: true
  validate :must_have_transaction
  validate :account_must_balance
  validate :must_in_working_period
  validate :open_balance_cannot_update

  private
  def account_must_balance
    total_debit = journal_entry_transactions.map(&:debit).compact.sum
    total_credit = journal_entry_transactions.map(&:credit).compact.sum
    balance = total_debit - total_credit
    unless balance == 0
      errors[:base] << I18n.t("journal_entries.validate_errors.balance_validate")
    end
  end

  def must_have_transaction
    if journal_entry_transactions.size <= 0
      errors[:base] << I18n.t("journal_entries.validate_errors.trans_validate")
    end
  end

  def must_in_working_period
    unless company.working_period.current_period? transaction_date
      errors[:base] << I18n.t("journal_entries.validate_errors.wrong_period",
        period: "Current working period: #{company.current_start_date_period} to #{company.current_end_date_period}")
    end
  end

  def open_balance_cannot_update
    if log_book.open_balance?
      errors[:base] << I18n.t("journal_entries.validate_errors.open_balance_validate")
    end
  end
end
