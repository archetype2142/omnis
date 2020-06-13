Spree::Price.class_eval do
  belongs_to :price_book  

  has_one :user, through: :price_book
end