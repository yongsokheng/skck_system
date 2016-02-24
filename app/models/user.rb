class User < ActiveRecord::Base
  has_many :journal_entries

  belongs_to :company

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:admin, :accountant]
end
