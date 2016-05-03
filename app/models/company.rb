class Company < ActiveRecord::Base
  has_many :chart_of_accounts, dependent: :destroy
  has_many :customer_venders
  has_many :journal_entries
  has_many :users, dependent: :destroy
  has_many :log_books
  has_many :bank_types
  has_one :working_period
  has_many :item_lists, dependent: :destroy
  has_many :measures
  has_many :unit_of_measures
  has_many :invoices

  def chart_account_tree
    tree_chart = []
    chart_of_accounts.roots.each do |account|
      tree_chart += account.chart_account
    end
    tree_chart
  end

  def current_start_date_period
    working_period.start_date
  end

  def current_end_date_period
    working_period.end_date
  end
end
