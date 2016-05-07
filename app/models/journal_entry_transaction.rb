class JournalEntryTransaction < ActiveRecord::Base
  belongs_to :journal, polymorphic: true
  belongs_to :chart_of_account
  belongs_to :customer_vender

  validates :chart_of_account_id, presence: true
  validate :name_must_exist_on_condition

  private
  def name_must_exist_on_condition
    account_type_code = Settings.account_type.map{|type| type.last}
    if chart_of_account.present? && account_type_code.include?(chart_of_account.chart_account_type.type_code) && customer_vender_id.blank?
      errors[:base] << I18n.t("journal_entries.validate_errors.name_validate")
    end
  end
end
