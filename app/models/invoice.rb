class Invoice < ActiveRecord::Base
  belongs_to :term
  belongs_to :customer_vender
  belongs_to :company

  has_many :invoice_transactions

  validates :transaction_date, presence: true
  validates :customer_vender_id, presence: true
  validate :must_have_transaction

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
end
