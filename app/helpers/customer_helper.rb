# frozen_string_literal: true

module CustomerHelper
  def users_table(users)
    render "admin/customers/clients/users_table", locals: { all_users: all_users }
  end

  def customer_show(client)
    render "admin/customers/clients/existing_client", locals: { client: client }
  end

  def customer_sales(client)
    render "admin/customers/clients/client_sales", locals: { client: client }
  end

  def customer_address(client)
    render "admin/customers/addresses/client_address", locals: { client: client }
  end

  def customer_filter_box
    render "admin/customers/clients/filter_box"
  end

  def client_tabs(tab_name)
    render "admin/layouts/clients/client_tabs", locals: { tab_name: tab_name} 
  end
end
