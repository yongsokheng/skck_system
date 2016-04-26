class Measure < ActiveRecord::Base
  belongs_to :company

  has_many :unit_of_measures

  scope :find_measures, ->{includes :unit_of_measures}
end
