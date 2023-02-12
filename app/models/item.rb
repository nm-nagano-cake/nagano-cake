class Item < ApplicationRecord
	has_one_attached :image

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end


  validates :name, presence: true
	validates :introduction, presence: true
	validates :price, 		  presence: true
# 	validates :sale_status, presence: true
	# ！！with optionでまとめる！！
	has_many :cart_items, dependent: :destroy
# 	belongs_to :genre
	enum sale_status: [:販売可, :販売不可]
end
