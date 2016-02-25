class CustomerVender < ActiveRecord::Base
  belongs_to :company

  has_many :journal_entry_transactions
end
