class LogBook < ActiveRecord::Base
  belongs_to :cash_type
  belongs_to :voucher_type
  belongs_to :company

  has_many :journal_entries, dependent: :destroy

  before_validation :format_reference_no, if: :transaction_data_exist?

  validates :transaction_date, presence: true
  validates :cash_type, presence: true
  validates :voucher_type, presence: true
  validates :reference_no, presence: true, uniqueness: {case_sensitive: false}
  validate :must_not_have_journal_entries, on: :update
  validate :transaction_date_must_in_current_period, unless: :open_balance?

  scope :find_reference_by, ->transaction_date, cash_type_id{
    where(transaction_date: transaction_date, cash_type_id: cash_type_id)
    .order transaction_date: :ASC}

  scope :find_reference_not_open_balance, ->transaction_date, cash_type_id{
    where(transaction_date: transaction_date, cash_type_id: cash_type_id, open_balance: 0)
    .order transaction_date: :ASC}

  scope :find_by_voucher_type, ->voucher_type_id, start_date, end_date{
    where("voucher_type_id = ? AND transaction_date >= ? AND transaction_date <= ?
      AND open_balance = 0", voucher_type_id, start_date, end_date)}

  scope :find_last_data, ->cash_type_id, voucher_type_id, start_date, end_date{
    where("cash_type_id = ? AND voucher_type_id = ? AND transaction_date >= ? AND transaction_date <= ?
      AND open_balance = 0", cash_type_id, voucher_type_id, start_date, end_date)
    .order(no: :DESC).limit 1
  }

  scope :find_uniq_data, ->transaction_date, cash_type_id, voucher_type_id{
    where(transaction_date: transaction_date, cash_type_id: cash_type_id,
    voucher_type_id: voucher_type_id, open_balance: 0)}

  scope :find_in_current_period, ->start_date, end_date{
    includes(:voucher_type, :cash_type, :journal_entries).where("transaction_date >= ? AND transaction_date <= ?
    AND open_balance = 0", start_date, end_date).order transaction_date: :ASC}

  class << self
    def create_or_find cash_type, company
      find_or_create_by! transaction_date: company.working_period.new_period,
        voucher_type_id: VoucherType.types[:civ], cash_type_id: cash_type.id,
        open_balance: true, company_id: company.id
    end

    def log_book_list transaction_date, cash_type_id
      find_reference_by(transaction_date, cash_type_id)
        .map{|logbook| [logbook.reference_no, logbook.id,
        "data-open_balance" => logbook.open_balance]}
    end
  end

  private
  def transaction_data_exist?
    transaction_date.present? && cash_type_id.present? && voucher_type_id.present?
  end

  def format_reference_no
    cash_type = CashType.types[:safe] == self.cash_type.id ? "S" : "B"
    if open_balance?
      voucher_type = ".OPENBL"
      self.reference_no = "#{Settings.company.branch}.#{cash_type}#{voucher_type}.#{I18n.l(self.transaction_date, format: :ref_format)}"
    else
      voucher_type = VoucherType.types[:civ] == self.voucher_type.id ? "I" : "O"
      logbook = LogBook.find_uniq_data transaction_date, cash_type_id, voucher_type_id
      if logbook.present?
        self.reference_no = logbook.last.reference_no
        self.no = logbook.last.no
      else
        working_period = company.working_period
        last_logbook = LogBook.find_last_data cash_type_id, voucher_type_id,
          working_period.start_date, working_period.end_date
        ref_no = last_logbook.present? ? last_logbook.last.no + 1 : 1
        self.no = ref_no
        self.reference_no = "#{Settings.company.branch}.#{cash_type}#{voucher_type}.#{I18n.l(self.transaction_date, format: :ref_format)}.#{sprintf('%02d', ref_no)}"
      end
    end
  end

  def must_not_have_journal_entries
    if journal_entries.any?
      errors[:base] << I18n.t("logbooks.validates.update_validate")
    end
  end

  def transaction_date_must_in_current_period
    if transaction_data_exist? && !company.working_period.current_period?(transaction_date)
      errors[:base] << I18n.t("logbooks.validates.transaction_date_validate")
    end
  end
end
