class WorkingPeriod < ActiveRecord::Base
  belongs_to :company

  def current_period? peroid
    peroid.to_date >= start_date && peroid.to_date <= end_date
  end
end
