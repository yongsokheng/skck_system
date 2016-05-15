class InvoiceTransaction < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :item_list
  belongs_to :sale_tax_code
  belongs_to :unit_of_measure

  validates :item_list_id, presence: true
  validates :price_each, presence: true, numericality: {greater_than: 0}

  def amount
    (quantity.blank? ? 1 : quantity.to_f) * price_each.to_f
  end

  def price_each= price_each
    price_each = price_each.gsub(",", "")
    self[:price_each] = price_each
  end
end
