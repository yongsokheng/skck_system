class Company < ActiveRecord::Base
  has_many :journal_entries
  has_many :users
  has_many :chart_of_accounts
  has_many :customer_venders
end
