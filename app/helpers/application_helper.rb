# frozen_string_literal: true

module ApplicationHelper
  include FrontendHelper
  include BaseHelper
  def available_countries
    countries = Spree::Country.all
    countries.collect do |country|
      country.name = I18n.t(country.iso, scope: 'country_names', default: country.name)
      country
    end
  end

  def fullname(user)
    return if user.addresses.empty?
    user.addresses&.first&.company || "#{user.addresses&.first&.firstname} #{user.addresses&.first&.lastname}"
  end

  def available_states(country_id)
    Spree::State.where(
      country: Spree::Country.find(country_id)
    )
  end

  # def display_price(product_or_variant)
  #   humanized_money ( product_or_variant.
  #   price_in(current_currency).
  #   display_price_including_vat_for(current_price_options) )
  # end

  def display_price(product_or_variant)
    money = Monetize.parse(product_or_variant.price)
    "<p class='amount'> #{money} <span class='symbol'> #{money.currency.symbol}</span></p>".html_safe
  end

  def current_currency
    'PLN'
  end

  def current_store
    @current_store ||= Spree::Store.current(request.env['SERVER_NAME'])
  end

  def current_price_options
    {
      tax_zone: current_tax_zone
    }
  end

  def current_tax_zone
    @current_tax_zone ||= @current_order&.tax_zone || Zone.default_tax
  end


  def currency_codes(which: [])
    currencies = []
    Money::Currency.table.values.each do |currency|
      if which.any?
        next unless which.include?(currency[:iso_code])
      end
      currencies = currencies + [[currency[:name] + ' (' + currency[:iso_code] + ')', currency[:iso_code]]]
    end
    currencies
  end

end
