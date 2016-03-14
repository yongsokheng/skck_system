class UnitOfMeasure < ActiveRecord::Base
  belongs_to :measure
  belongs_to :company
end
