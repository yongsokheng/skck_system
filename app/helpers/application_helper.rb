module ApplicationHelper
  def flash_class level
    case level
    when :notice then "alert-info"
    when :error then "alert-error"
    when :alert then "alert-warning"
    when :success then "alert-success"
    end
  end

  def logbook_form_title logbook
    logbook.new_record? ? t("logbooks.labels.add_title") : t("logbooks.labels.edit_title")
  end
end
