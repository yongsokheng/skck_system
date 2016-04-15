class ChartAccountType < ActiveRecord::Base
  has_many :chart_of_accounts

  validates :name, presence: true, length: {maximum: 255},
    uniqueness: {case_sensitive: false}

  enum increament_at: [:debit, :credit]

  scope :not_ar_ap, ->{where.not("type_code = 'ar' or type_code = 'ap'")}
end
