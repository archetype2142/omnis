module OrdersHelper
  def new_order_form
    render 'admin/orders/new_order_form'
  end

  def all_orders
    render 'admin/orders/all_orders'
  end
end