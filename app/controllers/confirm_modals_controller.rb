class ConfirmModalsController < ApplicationController
  def modal_customer_vender
    @customer_vender = CustomerVender.find params[:id]
    @status = params[:status]
  end

  def modal_chart_of_account
    @chart_of_account = ChartOfAccount.find params[:id]
    if  @chart_of_account.children.any?
      @type = Settings.confirm_modal_types.has_children
      @btn_state = "hidden"
    elsif @chart_of_account.inactive?
      @type = Settings.confirm_modal_types.active
      @btn_state = "btn-primary"
    elsif @chart_of_account.data_used?
      @type = Settings.confirm_modal_types.inactive
      @btn_state = "btn-warning"
    else
      @type = Settings.confirm_modal_types.destroy
      @btn_state = "btn-danger"
    end
  end
end
