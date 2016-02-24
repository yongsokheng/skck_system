class User < ActiveRecord::Base
  belongs_to :company

  has_many :chart_of_accounts
  has_many :journal_entries

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:admin, :accountant]
end
