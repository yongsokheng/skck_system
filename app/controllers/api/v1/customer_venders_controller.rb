module Api
  module V1
    class CustomerVendersController < Api::BaseController
      def index
        if params[:account_type] == Settings.account_type.ar
          data = current_user.company.customer_venders.customers
            .map{|customer| {text: customer.name, value: customer.id}}
        elsif params[:account_type] == Settings.account_type.ap
          data = current_user.company.customer_venders.venders
            .map{|vender| {text: vender.name, value: vender.id}}
        else
          data = []
        end
        respond_with data
      end
    end
  end
end
