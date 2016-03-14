class VoucherType < ActiveRecord::Base
  has_many :log_books

  enum type: {civ: 1, cov: 2}
end
