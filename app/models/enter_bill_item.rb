class EnterBillItem < ActiveRecord::Base
  belongs_to :unit_of_measure
  belongs_to :item_list
  belongs_to :enter_bill
end
