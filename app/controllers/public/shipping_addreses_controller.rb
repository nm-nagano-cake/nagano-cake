class Public::AddresesController < ApplicationController
  def index
    @shipping_addres_new = ShippingAddres.new
    @shipping_addreses = current_customer.shipping_addreses
  end

  def create
    @shipping_addres = shippingAddres.new(shipping_addres_params)
    @shipping_addres.customer_id = current_customer.id
    if @shipping_addres.save
       redirect_to shipping_addreses_path
    else
       @shipping_addres_new = shippingAddres.new
       @shipping_addreses = current_customer.shipping_addreses
       render :index
    end
  end

  def edit
    @shipping_addres = shippingAddres.find(params[:id])
  end

  def update
    shipping_addres = shippingAddres.find(params[:id])
    shipping_addres.update(shipping_addres_params)
    redirect_to shipping_addreses_path
  end

  def destroy
    shipping_addres = shippingAddres.find(params[:id])
    shipping_addres.destroy
    redirect_to shipping_addreses_path
  end

  private
  def shipping_addres_params
      params.require(:shipping_addres).permit(:last_name, :first_name, :postal_code, :address)
  end
end