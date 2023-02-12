class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  def index
    @orders = Order.where(customer_id:current_customer)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def new
    @addresses = current_customer.addresses
    @address = Address.new
    @order = Order.new
    @client = current_customer
  end

  #情報入力画面でボタンを押して情報をsessionに保存
  def create
     @order = Order.new(order_params)
     @order.customer_id = current_customer.id
     @order.save

     current_customer.cart_items.each do |cart_item| #カート内商品を1つずつ取り出しループ
    @session = OrderDetail.new #初期化宣言
    @session.order_id =  @order.id #order注文idを紐付けておく
      @session.item_id = cart_item.item_id #カート内商品idを注文商品idに代入
      @session.amount = cart_item.amount #カート内商品の個数を注文商品の個数に代入
      @session.price = (cart_item.item.price*1.08).floor #消費税込みに計算して代入
      @session.save #注文商品を保存
 end #ループ終わり

     current_customer.cart_items.destroy_all #カートの中身を削除
        redirect_to public_thanks_path





  end





  # 購入確認画面
  def confirm
    @order = Order.new(order_params)
    @cart_items = current_customer.cart_items.all # カートアイテムの情報をユーザーに確認してもらうために使用します
    @order.postage = 800
        @total = @cart_items.inject(0) { |sum, cart_item| sum + cart_item.sum_price }

    if params[:selected_address] == "radio1"
      @order.name = current_customer.first_name + current_customer.last_name
      @order.address = current_customer.address
      @order.postal_code = current_customer.postal_code

    elsif params[:selected_address] == "radio2"
      if Address.exists?(name: params[:order][:registered])

        @order.name = Address.find(params[:order][:registered]).name
        @order.address = Address.find(params[:order][:registered]).address
        @order.postal_code = current_customer.postal_code
      else
        render :new
      end
    elsif params[:selected_address] == "radio3"
       address_new = current_customer.addresses.new(address_params)
      if address_new.save
      else
      render :new

      end



    end
  end




  # 情報入力画面にて新規配送先の登録
  def create_address
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    @address.save
    redirect_to new_order_path
  end


  def create_order
    # オーダーの保存
    @order = Order.new
    @order.customer_id = current_customer.id
    @order.address = session[:address]
    @order.payment = session[:payment]
    @order.total_price = calculate(current_customer)
    @order.order_status = 0
    @order.save
    # saveができた段階でOrderモデルにorder_idが入る

    # オーダー商品ごとの詳細の保存
    current_customer.cart_items.each do |cart|
      @order_detail = OrderDetail.new
      @order_detail.order_id = @order.id
      @order_detail.item_name = cart.item.name
      @order_detail.item_price = cart.item.price
      @order_detail.quantity = cart.quantity
      @order_detail.item_status = 0
      @order_detail.save

    end
    current_customer.cart_items.destroy_all
    session.delete(:address)
    session.delete(:payment)
    redirect_to thanks_path
  end

  # 商品合計（税込）の計算
   def calculate(user)
     total_price = 0
     user.cart_items.each do |cart_item|
       total_price += cart_item.amount * cart_item.item.price
     end
     return (total_price * 1.1).floor
   end

    private
     def order_params
        params.require(:order).permit(:postage, :payment_method, :postal_code,:name, :address, :total_price, :order_status, :customer_id, :billing_amount)
     end


     def address_params
      params.require(:order).permit(:name, :address)
     end
  # private
  # def address_params
  #   params.require(:address).permit(:customer_id,:last_name, :first_name, :postal_code, :address)
  # end




end
