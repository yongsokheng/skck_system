class EnterBillExpense < ActiveRecord::Base
  belongs_to :chart_of_account
  belongs_to :enter_bill
end
