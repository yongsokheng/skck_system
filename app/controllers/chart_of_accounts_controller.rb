class ChartOfAccountsController < ApplicationController
  load_and_authorize_resource
  before_action :select_data, only: [:new, :create, :edit, :update]
  before_action :has_children, only: :destroy

  def index
    @chart_of_accounts = current_user.company.chart_of_accounts.roots
  end

  def new
  end

  def create
    @chart_of_account = @company.chart_of_accounts.new chart_of_account_params
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
    type = params[:type]
    @chart_of_account.send("#{type}")
    flash[:notice] = t "chart_of_accounts.flashs.#{type}"
    redirect_to chart_of_accounts_path
  end

  private
  def chart_of_account_params
    params.require(:chart_of_account).permit :name, :description, :account_no,
      :statement_ending_balance, :statement_ending_date,:chart_account_type_id,
      :parent_id
  end

  def select_data
    @company = current_user.company
    @chart_account_types = ChartAccountType.all
  end

  def has_children
    if @chart_of_account.children.any?
      flash[:alert] = t "chart_of_accounts.messages.has_children_confirm"
      redirect_to root_path
    end
  end
end
