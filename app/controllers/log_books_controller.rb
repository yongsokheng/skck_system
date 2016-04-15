class LogBooksController < ApplicationController
  load_and_authorize_resource
  before_action :load_data, only: [:index, :create, :update]
  before_action :load_item_select, only: [:new, :edit]

  def index
  end

  def new
  end

  def create
    if @log_book.save
      flash.now[:success] = t "logbooks.flashs.save_success"
    end
  end

  def edit
  end

  def update
    if @log_book.update_attributes log_book_params
      flash.now[:success] = t "logbooks.flashs.save_success"
    end
  end

  def destroy
    @log_book.destroy
    flash[:success] = t "logbooks.flashs.delete_success"
    redirect_to log_books_path
  end

  private
  def log_book_params
    params.require(:log_book).permit :transaction_date, :cash_type_id,
      :voucher_type_id, :company_id, :no
  end

  def load_data
    company = current_user.company
    period = company.working_period
    @log_books = company.log_books.find_in_current_period period.start_date, period.end_date
  end

  def load_item_select
    @cash_types = CashType.all
    @voucher_types = VoucherType.all
  end
end
