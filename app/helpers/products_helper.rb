# frozen_string_literal: true

module ProductsHelper
  def products_table(all_products)
    render "admin/products/products_table", locals: { all_products: @products }
  end

  def product_catetgory(product)
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
end