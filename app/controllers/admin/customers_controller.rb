class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

 
  def index
    @customers = Customer.page(params[:page]).per(10)
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_customer_path
    else
      flash[:customer_updated_error] = "会員情報が正常に保存されませんでした。"
      redirect_to edit_admin_customer_path(@customer)
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number, :email, :is_enabled)
  end
end