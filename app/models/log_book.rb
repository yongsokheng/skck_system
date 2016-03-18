class LogBook < ActiveRecord::Base
  belongs_to :cash_type
  belongs_to :voucher_type
  belongs_to :company

  has_many :journal_entries, dependent: :destroy

  before_validation :format_reference_no, if: :transaction_date_exist?

  validates :transaction_date, presence: true
  validates :reference_no, uniqueness: {case_sensitive: false}
  validate :must_not_have_journal_entries, on: :update
  validate :transaction_date_must_in_current_period, unless: :open_balance?

  scope :find_reference_by, ->transaction_date, cash_type_id{
    where(transaction_date: transaction_date, cash_type_id: cash_type_id)}

  scope :find_by_voucher_type, ->voucher_type_id, start_date, end_date{
    where("voucher_type_id = ? AND transaction_date >= ? AND transaction_date <= ?
      AND open_balance = false", voucher_type_id, start_date, end_date)
  }

  scope :find_except_open_balance, ->{where(open_balance: false).order transaction_date: :DESC}

  class << self
    def create_or_find cash_type, company
      find_or_create_by! transaction_date: company.working_period.new_period,
        voucher_type_id: VoucherType.types[:civ], cash_type_id: cash_type.id,
        open_balance: true, company_id: company.id
    end
  end

  private
  def transaction_date_exist?
    transaction_date.present?
  end

  def format_reference_no
    if open_balance?
      voucher_type = ".OPENBL"
    else
      voucher_type = VoucherType.types[:civ] == self.voucher_type.id ? "I" : "O"
    end
    cash_type = CashType.types[:safe] == self.cash_type.id ? "S" : "B"
    self.reference_no = "#{Settings.company.branch}.#{cash_type}#{voucher_type}.#{I18n.l(self.transaction_date, format: :ref_format)}"
  end

  def must_not_have_journal_entries
    if journal_entries.any?
      errors[:base] << I18n.t("logbooks.validates.update_validate")
    end
  end

  def transaction_date_must_in_current_period
    unless company.working_period.current_period? transaction_date
      errors[:base] << I18n.t("logbooks.validates.transaction_date_validate")
    end
  end
end
