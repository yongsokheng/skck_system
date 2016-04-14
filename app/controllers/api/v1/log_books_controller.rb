module Api
  module V1
    class LogBooksController < Api::BaseController
      def index
        logbook = current_user.company.log_books
          .find_reference_not_open_balance(params[:transaction_date], params[:cash_type_id])
          .map{|logbook| {value: logbook.id, text: logbook.reference_no,
            "open_balance" => logbook.open_balance}}
        respond_with logbook
      end
    end
  end
end
