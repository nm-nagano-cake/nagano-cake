class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

 def index
   @cart_items = current_customer.cart_items
   @total_price = calculate(current_customer)
 end

 def create
   @cart_item = CartItem.new(cart_item_params)
   @cart_item.customer_id = current_customer.id
   @update_cart_item=current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
   if @update_cart_item.present?
     @cart_item.amount += @update_cart_item.amount
    # @cart_item.amount + @update_cart_item.amount= @cart_item.amount
     @update_cart_item.destroy
   end
     
     @cart_item.save
     redirect_to cart_items_path
     
   
 end

 def update
   @cart_item = CartItem.find(params[:id])
   @cart_item.update(cart_item_params)
   redirect_to cart_items_path
 end

 def destroy
   cart_item = CartItem.find(params[:id])
   cart_item.destroy
   redirect_to cart_items_path
 end

 def destroy_all
   current_customer.cart_items.destroy_all
   redirect_to cart_items_path
 end

 private
 def cart_item_params
   params.require(:cart_item).permit(:customer_id, :item_id, :amount)
 end

 def calculate(user)
   total_price = 0
   user.cart_items.each do |cart_item|
     total_price += cart_item.amount * cart_item.item.price
   end
   return (total_price * 1.1).floor
 end
end