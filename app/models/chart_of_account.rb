class ChartOfAccount < ActiveRecord::Base
  belongs_to :chart_account_type
  belongs_to :company

  has_many :journal_entry_transactions

  def name_with_account_no
    "#{account_no} - #{name}"
  end
end
