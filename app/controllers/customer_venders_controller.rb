class CustomerVendersController < ApplicationController
  load_and_authorize_resource
  before_action :load_data, only: [:index, :new, :create, :edit, :update]

  def index
  end

  def show
  end

  def new
  end

  def create
    @customer_vender = @company.customer_venders.new customer_vender_params
    if @customer_vender.save
      flash.now[:success] = t "customer_vender.flashs.save_success"
    end
  end

  def edit
  end

  def update
    if @customer_vender.update_attributes customer_vender_params
      flash.now[:success] = t "customer_vender.flashs.update_success"
    end
  end

  def destroy
    @customer_vender.destroy
    flash[:success] = t "customer_vender.flashs.delete_success"
    redirect_to partners_path
  end

  private
  def customer_vender_params
    params.require(:customer_vender).permit :name, :email, :contact, :address, :status
  end

  def load_data
    @company = current_user.company
    @status = params[:status]
    @customer_venders = @company.customer_venders.where status: CustomerVender.statuses[@status]
  end
end
