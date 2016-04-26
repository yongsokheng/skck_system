class ChartOfAccountsController < ApplicationController
  load_and_authorize_resource
  before_action :company, only: [:index, :create]
  before_action :data_create, only: [:new, :create]
  before_action :data_edit, only: [:edit, :update]
  before_action :account_type_data, except: [:index, :destroy]
  before_action :set_company_id, only: :create

  def index
    @chart_of_accounts = @company.chart_of_accounts.find_data
  end

  def new
  end

  def create
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
      :statement_ending_balance, :statement_ending_date, :chart_account_type_id
  end

  def company
    @company = current_user.company
  end

  def data_create
    @account_types = ChartAccountType.all
  end

  def data_edit
    @account_types = @chart_of_account.selectize_data
  end

  def set_company_id
    @chart_of_account.company_id = @company.id
  end

  def account_type_data
    @account_types = @account_types.collect{|type| [type.name, type.id,
      {"data-acc_code" => type.type_code}]}
  end
end
