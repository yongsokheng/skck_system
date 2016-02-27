class BankType < ActiveRecord::Base
  belongs_to :cash_type
  belongs_to :company

  has_many :journal_entries
end
