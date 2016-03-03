class Measure < ActiveRecord::Base
  belongs_to :company

  has_many :unit_of_measures
end
