# frozen_string_literal: true

module NavigationHelper
  def sidebar items
    render "layouts/aside_menu", locals: items 
  end

  def single_product_sidebar_items(product)
    {
      'type': product.name,
      items: {
        'New Product': new_admin_product_path,
        'All Products': admin_products_path,
        'Images': admin_product_images_path(product.id)
      }
    }
  end

  def client_sidebar_items
    {
      'type': 'Customer Settings',
      items: {
        'New Order': new_admin_order_path,
        'Order History': "#{admin_customers_orders_path(id: user.id) if user}",
        'Addresses': "#{admin_customers_address_path(user) if user}"
      }
    }
  end

  def product_sidebar_items
    {
      'type': 'Product Settings',
      items: {
        'New Product': new_admin_product_path,
        'All Products': admin_products_path
      }
    }
  end

end