class Company < ActiveRecord::Base
  has_many :chart_of_accounts, dependent: :destroy
  has_many :customer_venders
  has_many :journal_entries
  has_many :users, dependent: :destroy
  has_many :log_books
  has_many :bank_types

  def chart_account_tree
    tree_chart = []
    chart_of_accounts.roots.each do |account|
      tree_chart += account.chart_account
    end
    tree_chart
  end
end
