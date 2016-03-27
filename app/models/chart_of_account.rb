class ChartOfAccount < ActiveRecord::Base
  has_closure_tree

  belongs_to :chart_account_type
  belongs_to :company
  belongs_to :user

  has_many :journal_entry_transactions
  has_many :item_lists

  validates :account_no, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: 255}
  validates :statement_ending_balance, numericality: {greater_than_or_equal_to: 0}, if: :ending_balance_exist?
  validate :name_existed

  delegate :name, :id, to: :chart_account_type, prefix: true, allow_nil: true

  enum status: [:inactive, :active]

  def chart_account chart_arr = []
    chart_arr << [chart_account_name, id, {"depth" => depth}, {"type" => chart_account_type.type_code}, {"status" => status}]
    children.each do |child|
      child.chart_account chart_arr
    end
    chart_arr
  end

  class << self
    def chart_account_tree account_arr = [{id: ""}], account_roots
      account_roots.each do |account|
        account_arr << {id: account.id, text: account.name, depth: account.depth,
          type: account.chart_account_type.name, no: account.account_no, status: account.status}
        account.children.each do |child|
          account_arr << {id: child.id, text: child.name, depth: child.depth,
            type: child.chart_account_type.name, no: child.account_no, status: child.status}
          chart_account_tree account_arr, child.children
        end
      end
      account_arr
    end
  end

  def chart_account_name
    "#{account_no}|#{name}|#{chart_account_type.name}"
  end

  def balance_total
    total_debit = journal_entry_transactions.sum :debit
    total_credit = journal_entry_transactions.sum :credit
    balance = chart_account_type.debit? ? (total_debit - total_credit) : (total_credit - total_debit)
    balance += statement_ending_balance
  end

  def data_used?
    journal_entry_transactions.present? || item_lists.present?
  end

  def active
    update_attributes status: :active
  end

  def inactive
    update_attributes status: :inactive
  end

  private
  def ending_balance_exist?
    statement_ending_balance.present?
  end

  def name_existed
    if parent_id.present?
      children_name = ChartOfAccount.find(parent_id).children.where.not(id: id).map(&:name)
    else
      children_name = ChartOfAccount.roots.where.not(id: id).map(&:name)
    end
    errors.add :name, I18n.t("chart_of_accounts.messages.existed") if
      children_name.map(&:downcase).include? name.downcase
  end
end
