class JournalEntry < ActiveRecord::Base
  has_many :journal_entry_transactions

  belongs_to :user
  belongs_to :company

  accepts_nested_attributes_for :journal_entry_transactions,
    reject_if: proc {|attributes| attributes[:debit].blank? && attributes[:credit].blank?},
    allow_destroy: true

  validates :transaction_date, presence: true
  validate :must_have_transaction
  validate :account_must_balance

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
end
