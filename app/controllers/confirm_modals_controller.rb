class ConfirmModalsController < ApplicationController
  def modal_customer_vender
    @customer_vender = CustomerVender.find params[:id]
    @status = params[:status]
  end

  def modal_chart_of_account
    @chart_of_account = ChartOfAccount.find params[:id]
    if !@chart_of_account.active?
      @type = Settings.confirm_modal_types.update_active
      @btn_state = "btn-success"
    elsif @chart_of_account.data_used?
      @type = Settings.confirm_modal_types.update_inactive
      @btn_state = "btn-warning"
    else
      @type = Settings.confirm_modal_types.destroy
      @btn_state = "btn-danger"
    end
  end

  def modal_bank_type
    @bank_type = BankType.find params[:id]
    if @bank_type.data_used?
      @type = Settings.confirm_modal_types.data_used
      @btn_state = "hidden"
    else
      @type = Settings.confirm_modal_types.destroy
      @btn_state = "btn-danger"
    end
  end

  def modal_log_book
    @logbook = LogBook.find params[:id]
  end
end
