class LogBook < ActiveRecord::Base
  belongs_to :cash_type
  belongs_to :voucher_type
  belongs_to :company

  has_many :journal_entries

  before_validation :format_reference_no, if: :transaction_date_exist?

  validates :transaction_date, presence: true
  validates :reference_no, uniqueness: {case_sensitive: false}

  scope :find_reference_by, ->transaction_date, cash_type_id{where(transaction_date: transaction_date, cash_type_id: cash_type_id)}
  private

  def transaction_date_exist?
    transaction_date.present?
  end

  def format_reference_no
    voucher_type = Settings.voucher_types.civ == self.voucher_type.abbreviation.downcase ? "I" : "O"
    cash_type = Settings.cash_types.safe == self.cash_type.name.downcase ? "S" : "B"
    self.reference_no = "#{Settings.company.branch}.#{cash_type}#{voucher_type}.#{I18n.l(self.transaction_date, format: :ref_format)}"
  end
end
