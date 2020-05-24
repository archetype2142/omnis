# frozen_string_literal: true

module ProductsHelper
  def products_table(all_products)
    render "admin/products/products_table", locals: { all_products: all_products }
  end

  def product_catetgory(product)
    product
    .taxons
    .preload(:taxonomy)
    .map { |t| t.taxonomy }
    .pluck(:name)
    .join(",")
  end
end