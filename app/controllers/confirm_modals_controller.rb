class ConfirmModalsController < ApplicationController
  def modal_customer_vender
    @customer_vender = CustomerVender.find params[:id]
    @status = params[:status]
  end
end
