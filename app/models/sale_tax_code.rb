class SaleTaxCode < ActiveRecord::Base
  belongs_to :company

  has_many :invoice_transactions
end
