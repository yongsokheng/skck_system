class SaleReceipt < ActiveRecord::Base
  belongs_to :customer_vender
  belongs_to :company
  belongs_to :chart_of_account
  belongs_to :bank_type
  belongs_to :log_book

  has_many :sale_receipt_transactions, dependent: :destroy

  validates :transaction_date, presence: true
  validates :customer_vender_id, presence: true
  validates :chart_of_account_id, presence: true
  validates :bank_type_id, presence: true
  validates :log_book_id, presence: true
  validate :must_have_transaction
  validate :must_in_working_period

  accepts_nested_attributes_for :sale_receipt_transactions,
  reject_if: proc {|attributes| attributes[:item_list_id].blank? &&
    ((attributes[:quantity].blank? ? 1 : attributes[:quantity].to_f) * attributes[:price_each].to_f) == 0},
    allow_destroy: true

  private
  def must_have_transaction
    if sale_receipt_transactions.size <= 0
      errors[:base] << I18n.t("sale_receipt.validate_errors.trans_validate")
    end
  end

  def must_in_working_period
    unless company.working_period.current_period? transaction_date
      errors[:base] << I18n.t("sale_receipt.validate_errors.wrong_period")
    end
  end
end
