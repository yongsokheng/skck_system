class InvoiceTransaction < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :item_list
  belongs_to :sale_tax_code
  belongs_to :unit_of_measure

  has_many :journal_entry_transactions, as: :journal, dependent: :destroy

  validates :item_list_id, presence: true

  delegate :chart_of_account_id, to: :item_list, prefix: true, allow_nil: true

  accepts_nested_attributes_for :journal_entry_transactions,
    reject_if: proc {|attributes| attributes[:chart_of_account_id].blank?},
    allow_destroy: true

  def amount
    (quantity.blank? ? 1 : quantity.to_f) * price_each.to_f
  end
end
