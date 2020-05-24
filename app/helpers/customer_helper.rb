# frozen_string_literal: true

module CustomerHelper
  def users_table(users)
    render "admin/customers/clients/users_table", locals: { all_users: all_users }
  end
end