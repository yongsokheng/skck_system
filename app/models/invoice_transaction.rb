class InvoiceTransaction < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :item_list
  belongs_to :sale_tax_code
  belongs_to :unit_of_measure

  validates :item_list_id, presence: true

  private
  def amount
    (quantity.blank? ? 1 : quantity.to_f) * price_each.to_f
  end
end
