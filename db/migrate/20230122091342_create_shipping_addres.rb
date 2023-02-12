class CreateShippingAddres < ActiveRecord::Migration[6.1]
  def change
    create_table :shipping_addres do |t|
      
      t.integer :customer_id,   null: false, default: ""
      # 外部キー 会員のID
      t.string  :last_name,     null: false, default: ""
      t.string  :first_name,    null: false, default: ""
      t.string  :postal_code,     null: false, default: ""
      t.text    :address,       null: false, default: ""


      t.timestamps
    end
  end
end
