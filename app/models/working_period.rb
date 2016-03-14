class WorkingPeriod < ActiveRecord::Base
  belongs_to :company

  validates :start_date, presence: true
  validates :end_date, presence: true

  def current_period? period
    period.to_date >= start_date && period.to_date <= end_date
  end

  def new_period
    end_date + 1.day
  end

  def update_period
    start_period = new_period
    end_period = start_period.end_of_month
    update_attributes start_date: start_period, end_date: end_period
  end
end
