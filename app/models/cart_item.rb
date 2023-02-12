class CartItem < ApplicationRecord
  validates :amount, presence: true
   # 数量0以下に変更して保存されないように
   belongs_to :customer
   belongs_to :item

   def validate_into_cart
      cart_items = self.customer.cart_items
      if (amount) == nil
         return (false)
      elsif cart_items.any? {|cart_item| cart_item.item_id == (item_id)} == true
         return (false)
      else
        return (true)
      end
   end
   def sum_price
     item.price * amount
   end
end
