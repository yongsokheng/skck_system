class CashType < ActiveRecord::Base
  has_many :log_books
  has_many :bank_types

  enum type: {safe: 1, bank: 2}
end
