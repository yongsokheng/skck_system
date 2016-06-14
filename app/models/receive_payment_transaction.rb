class ReceivePaymentTransaction < ActiveRecord::Base
  belongs_to :receive_payment
  belongs_to :invoice

  validates :invoice_id, presence: true
  validates :payment, presence: true, numericality: {greater_than: 0}
  validate :payment_must_less_than_due_amount

  scope :find_transaction_except, ->receive_payment{where.not receive_payment: receive_payment}

  after_save :update_invoice_paid
  after_destroy :update_invoice_paid

  def payment= payment
    payment = payment.gsub(",", "")
    self[:payment] = payment
  end

  private
  def payment_must_less_than_due_amount
    if payment > invoice.amount_due(receive_payment)
      errors[:base] << I18n.t("receive_payments.validate_errors.wrong_payment")
    end
  end

  def update_invoice_paid
    Invoice.find(invoice.id).update_paid
  end
end
