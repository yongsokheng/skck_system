module Api
  module V1
    class JournalEntriesController < Api::BaseController
      def index
        journal_entry = current_user.company.journal_entries.find_by log_book_id: params[:log_book_id], bank_type_id: params[:bank_type_id]
        respond_with journal_entry
      end
    end
  end
end
