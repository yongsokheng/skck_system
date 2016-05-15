module ApplicationHelper
  def flash_class level
    case level
    when :notice then "alert-info"
    when :error then "alert-error"
    when :alert then "alert-warning"
    when :success then "alert-success"
    end
  end

  def form_title object
    object.new_record? ? t("labels.add_title") : t("labels.edit_title")
  end

  def customer_vender_state object
    (object.active? ? "<span class='label label-success'>#{object.state}</span>" : "<span class='label label-warning'>#{object.state}</span>").html_safe
  end

  def chart_of_account_status object
    (object.active? ? "<span class='label label-success'>" + t("chart_of_accounts.actions.active") + "</span>" : "<span class='label label-warning'>" + t("chart_of_accounts.actions.inactive") + "</span>").html_safe
  end

  def format_number number
    number_with_precision number, precision: 2, delimiter: ","
  end
end
