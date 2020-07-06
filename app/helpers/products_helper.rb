# frozen_string_literal: true

module ProductsHelper
  def products_table(all_products)
    render "admin/products/products_table", locals: { all_products: @products }
  end

  def product_category(product)
    product
    .taxons
    .pluck(:name)
    .join(",")
    .truncate(20)
  end

  def products_filter_box
    render "admin/products/filter_box"
  end

  def product_tabs(tab_name)
    render "admin/layouts/products/product_tabs", locals: { tab_name: tab_name} 
  end

  def out_of_stock_products_count
    Spree::Product.joins(variants: :stock_items).where(
      'count_on_hand > ? OR spree_variants.track_inventory = ?', 
      0, 
      false
    ).count
  end

  def top_seller
    Spree::Product.active.select("spree_products.*, SUM(spree_line_items.quantity) as total_qty, spree_line_items.variant_id").
    joins(:line_items).joins("INNER JOIN spree_orders ON spree_orders.id = spree_line_items.order_id").
    where("spree_orders.state = 'complete'").
    group("spree_line_items.variant_id, spree_products.id").order("total_qty DESC")
  end

  def top_seller_fake
    Spree::Product.all.select { |p| p.images.any? }
  end
end