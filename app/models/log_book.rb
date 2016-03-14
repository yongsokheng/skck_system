class LogBook < ActiveRecord::Base
  belongs_to :cash_type
  belongs_to :voucher_type
  belongs_to :company

  has_many :journal_entries

  before_validation :format_reference_no, if: :transaction_date_exist?

  validates :transaction_date, presence: true
  validates :reference_no, uniqueness: {case_sensitive: false}

  scope :find_reference_by, ->transaction_date, cash_type_id{
    where(transaction_date: transaction_date, cash_type_id: cash_type_id)}

  scope :find_by_voucher_type, ->voucher_type_id, start_date, end_date{
    where("voucher_type_id = ? AND transaction_date >= ? AND transaction_date <= ?
      AND open_balance = false", voucher_type_id, start_date, end_date)
  }

  class << self
    def create_log_book cash_type_id, company
      create! transaction_date: company.working_period.new_period,
        voucher_type_id: VoucherType.types[:civ], cash_type_id: cash_type_id,
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
end
