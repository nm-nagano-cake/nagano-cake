Rails.application.routes.draw do

  # get 'publics/confirmations'
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, controllers: {
    sessions:      'admin/sessions',
    passwords:     'admin/passwords',
    registrations: 'admin/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlscope module: :customers do
   #admin
  scope module: :public do
    root 'homes#top'
    # 商品
    resources :items, only: %i(show index)
    get 'genres/:id/genre_items' => 'items#genre_items'
    # 注文
    # post "orders/pre_create" => "orders#pre_create"
    post "orders/confirm" => "orders#confirm"
    resources :orders, only: [:new, :show, :create, :index]
    # 会員
    get "customers/unsubscribe" => "customers#unsubscribe"
    patch "customers/withdrawal" => "customers#withdrawal"
    resources :customers, only: [:show, :edit, :update, :destroy]
    # カート
    resources :cart_items, only: [:create, :index, :update, :destroy]
    delete 'cart_items' => 'cart_items#destroy_all'
    # 登録先住所
    # resources :shipping_addreses, only: %i(new show create edit update destroy)
  end
  #admin
  namespace :admin do
    root 'homes#top'
    resources :customers, only: [:show, :index, :edit, :update]
    resources :items,only: [:new, :show, :create, :edit, :index, :update]
    resources :genres, except: [:new, :show, :destroy]
    resources :orders, only: [:index, :show]
    get '/customer_datas/:id/orders' => 'orders#index', as: "customer_data_orders" # 会員詳細 => 注文履歴の表示データを変える用
    get '/yesterday/orders' => 'orders#index', as: "yesterday_orders" # TOP,本日製作分の注文数 => 注文履歴の表示データ用
    get '/today/orders' => 'orders#index', as: "today_orders" # TOP,本日受注した注文数 => 注文履歴の表示データ用
    patch '/orders/:id/order_status' => 'orders#order_status_update', as: "order_status" # 注文ステータスupdate
    patch '/orders/:id/item_status' => 'orders#item_status_update', as: "item_status" # 製作ステータスupdate
  end

  namespace :public do
  #customer
    root 'homes#top'

    get '/thanks' => 'homes#thanks' #サンクスページ
    get '/orders/confirm_order' => 'orders#confirm', as: 'orders_confirm' #購入確認画面への遷移
    post '/orders/pre_create' => 'orders#create_order' #購入確定のアクション
    post '/shipping_addreses' => 'orders#create_ship_address' #情報入力画面での配送先登録用のアクション
    delete '/cart_items' => 'cart_items#destroy_all' #カートアイテムを全て削除

    resources :shipping_addreses, except: [:index, :edit, :create, :update, :destroy]
    resources :cart_items, except: [:new, :show, :edit]
    resources :items, only: [:index, :show]
    resources :addresses, only: [:index, :edit, :create, :update, :destroy]
    resources :genres, only: [:index] do
      resources :items, only: [:index]

    end
    resources :orders, except: [:edit, :update, :destroy]
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
end