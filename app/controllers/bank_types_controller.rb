class BankTypesController < ApplicationController
  load_and_authorize_resource

  before_action :load_company
  before_action :load_cash_type_data, only: [:new, :edit]
  before_action :load_bank_type_data, only: [:index, :create, :update, :destroy]

  def index
  end

  def new
  end

  def create
    if @bank_type.save
      flash[:notice] = t "flashs.messages.created"
    end
  end

  def edit
  end

  def update
    if @bank_type.update_attributes bank_type_params
      flash[:notice] = t "flashs.messages.updated"
    end
  end

  def destroy
    if @bank_type.data_used?
      flash[:alert] = t "flashs.messages.data_used"
    else
      @bank_type.destroy
      flash[:notice] = t "flashs.messages.deleted"
    end
    redirect_to bank_types_path
  end

  private
  def load_company
    @company = current_user.company
  end

  def load_cash_type_data
    @cash_types = CashType.all
  end

  def load_bank_type_data
    @bank_types = @company.bank_types
  end

  def bank_type_params
    params.require(:bank_type).permit :name, :cash_type_id, :company_id
  end
end
