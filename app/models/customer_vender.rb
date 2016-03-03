class CustomerVender < ActiveRecord::Base
  belongs_to :company

  has_many :item_lists
  has_many :journal_entry_transactions
end
