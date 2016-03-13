module Api
  module V1
    class ChartOfAccountsController < Api::BaseController
      def index
        company_id = current_user.company.id
        roots = ChartOfAccount.roots.where(company_id: company_id, chart_account_type_id: params[:chart_account_type_id])
        chart_account_tree = ChartOfAccount.chart_account_tree(roots)
        respond_with chart_account_tree
      end
    end
  end
end
