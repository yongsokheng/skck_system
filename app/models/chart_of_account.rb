class ChartOfAccount < ActiveRecord::Base
  has_closure_tree

  belongs_to :chart_account_type
  belongs_to :company
  belongs_to :user

  has_many :journal_entry_transactions

  validates :account_no, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: 255}
  validates :statement_ending_balance, numericality: {greater_than_or_equal_to: 0}, if: :ending_balance_exist?
  validate :name_existed

  delegate :name, :id, to: :chart_account_type, prefix: true, allow_nil: true

  def chart_account chart_arr = []
    chart_arr << [chart_account_name, id, {"depth" => depth}, {"type" => chart_account_type.type_code}]
    children.each do |child|
      child.chart_account chart_arr
    end
    chart_arr
  end

  def chart_account_name
    "#{account_no}|#{name}|#{chart_account_type.name}"
  end

  private
  def ending_balance_exist?
    statement_ending_balance.present?
  end

  def name_existed
    if parent_id.present?
      children_name = ChartOfAccount.find(parent_id).children.where.not(id: id).map(&:name)
    else
      children_name = ChartOfAccount.roots.map(&:name)
    end
    errors.add :name, I18n.t("chart_of_accounts.messages.existed") if
      children_name.map(&:downcase).include? name.downcase
  end
end
