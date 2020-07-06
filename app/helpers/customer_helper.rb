# frozen_string_literal: true

module CustomerHelper
  def users_table(users)
    render "admin/customers/clients/users_table", locals: { all_users: all_users }, cached: true
  end

  def customer_show(client)
    render "admin/customers/clients/existing_client", locals: { client: client }, cached: true
  end

  def customer_sales(client)
    render "admin/customers/clients/client_sales", locals: { client: client }, cached: true
  end

  def customer_address(client)
    render "admin/customers/addresses/client_address", locals: { client: client }, cached: true
  end

  def customer_filter_box
    render "admin/customers/clients/filter_box", cached: true
  end

  def client_tabs(tab_name)
    render "admin/layouts/clients/client_tabs", locals: { tab_name: tab_name}, cached: true
  end

  def client_prices_table
    render "admin/customers/prices/client_prices_table", locals: { user: user }, cached: true
  end

  def client_price_filter_box
    render "admin/customers/prices/filter_box", cached: true
  end
end
