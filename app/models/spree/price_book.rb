module Spree
  class PriceBook < Spree::Base
    belongs_to :user
    belongs_to :company
    
    has_many :prices
    has_many :variants, through: :prices
    has_many :products, -> { uniq }, through: :variants
    scope :active, -> {
    where("#{table_name}.default = ? OR (#{table_name}.active_from <= ? AND (#{table_name}.active_to IS NULL OR #{table_name}.active_to >= ?))",
      true, Time.zone.now, Time.zone.now)
    }

    def active?
      # TODO I'm using .to_i in here because I stumbled on a strange bug:
      # [1] surfdome(#<Spree::PriceBook>) »  active_to
      # => Wed, 19 Feb 2014 16:29:04 UTC +00:00
      # [2] surfdome(#<Spree::PriceBook>) »  Time.zone.now
      # => Wed, 19 Feb 2014 16:29:04 UTC +00:00
      # [3] surfdome(#<Spree::PriceBook>) »  active_to >= Time.zone.now
      # => false
      # [5] surfdome(#<Spree::PriceBook>) »  active_to.to_s(:number)
      # => "20140219162904"
      # [6] surfdome(#<Spree::PriceBook>) »  Time.zone.now.to_s(:number)
      # => "20140219162904"
      # [1] surfdome(#<Spree::PriceBook>) »  active_to.to_i
      # => 1392827718
      # [2] surfdome(#<Spree::PriceBook>) »  Time.zone.now.to_i
      # => 1392827718
      # [3] surfdome(#<Spree::PriceBook>) »  active_to.to_i >= Time.zone.now.to_i
      # => true
      default? or (active_from.present? and active_from <= Time.zone.now and (active_to.blank? or active_to.to_i >= Time.zone.now.to_i))
    end

    def self.create_default
      create(currency: Spree::Config[:currency], default: true, name: 'Default')
    end

    def self.default
      if default = where(default: true).first
        default
      else
        create_default
      end
    end

    def add_product(product)
      variants = product.variants_including_master
      variants.each { |variant|
        self.add_variant(variant) }
    end

    def add_product_by_id(product_id)
      product = Spree::Product.find(product_id)
      add_product(product) if product.present?
    end

    def add_variant(variant)
      price = self.prices.where(variant_id: variant.id).first
      if price.blank?
        self.prices << Spree::Price.create(
          variant_id: variant.id,
          amount: variant.price,
          currency: self.currency
        )
      end
    end
  end
end