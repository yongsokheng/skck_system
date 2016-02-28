class Company < ActiveRecord::Base
  has_many :chart_of_accounts, dependent: :destroy
  has_many :customer_venders
  has_many :journal_entries
  has_many :users, dependent: :destroy
end
