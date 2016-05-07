class InvoiceService

  def initialize invoice, invoice_params = nil
    @invoice = invoice
    @invoice_params = invoice_params
  end

  def save
    @success = ActiveRecord::Base.transaction do
      begin
        if @invoice.new_record?
          @invoice.save!
        else
          @invoice.update_attributes! @invoice_params
        end
        account_receivable = @invoice.chart_of_account_id
        customer_vender_id = @invoice.customer_vender_id

        @invoice.invoice_transactions.includes(:item_list).each do |invoice_transaction|

          account_income = invoice_transaction.item_list_chart_of_account_id
          amount = invoice_transaction.amount
          description = invoice_transaction.description

          @transaction = invoice_transaction.journal_entry_transactions.includes :chart_of_account
          if @transaction.present?
            @transaction.first.update_attributes! chart_of_account_id: account_receivable,
              debit: amount, description: description, customer_vender_id: customer_vender_id

            @transaction.second.update_attributes! chart_of_account_id: account_receivable,
              credit: amount, description: description, customer_vender_id: customer_vender_id
          else
            @transaction.create! chart_of_account_id: account_receivable,
              debit: amount, description: description, customer_vender_id: customer_vender_id

            @transaction.create! chart_of_account_id: account_income,
              credit: amount, description: description, customer_vender_id: customer_vender_id
          end
        end
        true
      rescue
        raise ActiveRecord::Rollback
        false
      end
    end
    @success
  end
end
