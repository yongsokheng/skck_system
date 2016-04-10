class CustomerVender < ActiveRecord::Base
  belongs_to :company

  has_many :item_lists
  has_many :journal_entry_transactions

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  enum status: [:customer, :vender]
  enum state: [:inactive, :active]

  scope :customers, ->{where status: statuses[:customer]}
  scope :venders, ->{where status: statuses[:vender]}

  def active
    update_attributes state: :active
  end

  def inactive
    update_attributes state: :inactive
  end
end
