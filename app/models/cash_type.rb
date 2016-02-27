class CashType < ActiveRecord::Base
  has_many :log_books
  has_many :bank_types
end
