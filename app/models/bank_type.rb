class BankType < ActiveRecord::Base
  belongs_to :cash_type
  belongs_to :company

  has_many :journal_entries

  validates :name, presence: true, length: {maximum: 255},
    uniqueness: {case_sensitive: false}
  validates :cash_type, presence: true

  enum status: [:inactive, :active]

  scope :find_data, ->{includes(:cash_type).order(name: :ASC)}

  delegate :id, :name, to: :cash_type, prefix: true, allow_nil: true

  def open_balance voucher_type_id
    current_period = company.working_period
    log_books = company.log_books.find_by_voucher_type(voucher_type_id,
      current_period.start_date, current_period.end_date).map(&:id)
    journal_entries.where(log_book_id: log_books)
      .map{|journal| journal.journal_entry_transactions.sum(:debit)}.sum
  end

  def total_open_balance
    balance_in = open_balance VoucherType.types[:civ]
    balance_out = open_balance VoucherType.types[:cov]
    open_balance = balance_in - balance_out

    log_book = company.log_books.find_by transaction_date: company.working_period.start_date,
      cash_type_id: cash_type.id, open_balance: true

    if log_book.present?
      last_open_balance = JournalEntry.find_by(log_book_id: log_book.id,
        bank_type_id: id).journal_entry_transactions.first.debit
      open_balance +=last_open_balance
    end
    open_balance
  end

  def data_used?
    journal_entries.any?
  end
end
