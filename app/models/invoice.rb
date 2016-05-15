class Invoice < ActiveRecord::Base
  belongs_to :customer_vender
  belongs_to :company

  has_many :invoice_transactions, dependent: :destroy

  validates :transaction_date, presence: true
  validates :customer_vender_id, presence: true
  validate :must_have_transaction
  validate :must_in_working_period

  accepts_nested_attributes_for :invoice_transactions,
    reject_if: proc {|attributes| attributes[:item_list_id].blank? &&
      ((attributes[:quantity].blank? ? 1 : attributes[:quantity].to_f) * attributes[:price_each].to_f) == 0},
      allow_destroy: true

  private
  def must_have_transaction
    if invoice_transactions.size <= 0
      errors[:base] << I18n.t("create_invoice.validate_errors.trans_validate")
    end
  end

  def must_in_working_period
    unless company.working_period.current_period? transaction_date
      errors[:base] << I18n.t("create_invoice.validate_errors.wrong_period")
    end
  end
end
