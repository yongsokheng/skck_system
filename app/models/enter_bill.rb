class EnterBill < ActiveRecord::Base
  belongs_to :customer_vender
  belongs_to :company

  has_many :enter_bill_expenses
  has_many :enter_bill_items

  accepts_nested_attributes_for :enter_bill_expenses, allow_destroy: true

  accepts_nested_attributes_for :enter_bill_items,
    reject_if: proc {|attributes| attributes[:item_list_id].blank? &&
      ((attributes[:quantity].blank? ? 1 : attributes[:quantity].to_f) * attributes[:price_each].to_f) == 0},
      allow_destroy: true

end
