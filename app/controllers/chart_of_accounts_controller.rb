class ChartOfAccountsController < ApplicationController
  load_and_authorize_resource
  before_action :select_data, only: [:new, :create, :edit, :update]

  def index
    @chart_of_accounts = ChartOfAccount.roots
  end

  def new
  end

  def create
    company = current_user.company
    @chart_of_account = company.chart_of_accounts.new chart_of_account_params
    if @chart_of_account.save
      flash[:notice] = t "flashs.messages.created"
      redirect_to chart_of_accounts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @chart_of_account.update_attributes chart_of_account_params
      flash[:notice] = t "flashs.messages.updated"
      redirect_to chart_of_accounts_path
    else
      render :edit
    end
  end

  def destroy
    @chart_of_account.destroy
    redirect_to chart_of_accounts_path
  end

  private
  def chart_of_account_params
    params.require(:chart_of_account).permit :name, :description, :account_no,
      :statement_ending_balance, :statement_ending_date,:chart_account_type_id,
      :parent_id, :user_id
  end

  def select_data
    @chart_account_types = ChartAccountType.all
    @parents = ChartOfAccount.chart_account_tree
  end
end
