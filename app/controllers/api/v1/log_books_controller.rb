module Api
  module V1
    class LogBooksController < Api::BaseController
      def index
        logbook = current_user.company.log_books
          .find_reference_by(params[:transaction_date], params[:cash_type_id])
          .map{|logbook| {id: logbook.id, text: logbook.reference_no}}
        respond_with logbook
      end
    end
  end
end
