module LogBookHelper
  def is_current_period? log_book
    log_book.company.working_period.current_period? log_book.transaction_date
  end
end
