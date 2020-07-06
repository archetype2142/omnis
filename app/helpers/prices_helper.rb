module PricesHelper
  def edit_price_form
    render "admin/prices/edit_price_form"
  end

  def new_price_form
    render "admin/prices/new_price_form"
  end

  def prices_table
    render "admin/prices/prices_table"
  end
end