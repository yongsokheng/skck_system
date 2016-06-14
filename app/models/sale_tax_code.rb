class SaleTaxCode < ActiveRecord::Base
  belongs_to :company

  has_many :invoice_transactions
  has_many :sale_receipt_transactions
end
