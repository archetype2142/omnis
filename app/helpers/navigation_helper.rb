# frozen_string_literal: true

module NavigationHelper
  def sidebar items
    render "layouts/aside_menu", locals: items 
  end
end