module BaseHelper
  def sale_today
    total = Spree::Order.created_between(
      DateTime.now.beginning_of_day, 
      DateTime.now.end_of_day
    ).map do |o|
      next if o.currency != current_currency
      o.total
    end.inject(0, :+)

    Spree::Money.new(total, currency: current_currency)
  end

  def orders_today
    Spree::Order.created_between(
      DateTime.now.beginning_of_day, 
      DateTime.now.end_of_day
    ).count
  end

  def field_container(model, method, options = {}, &block)
    css_classes = options[:class].to_a
    css_classes << 'field'
    css_classes << 'withError' if error_message_on(model, method).present?
    content_tag(
      :div, capture(&block),
      options.merge(class: css_classes.join(' '), id: "#{model}_#{method}_field")
    )
  end

  def error_message_on(object, method, _options = {})
    object = convert_to_model(object)
    obj = object.respond_to?(:errors) ? object : instance_variable_get("@#{object}")

    if obj && obj.errors[method].present?
      errors = safe_join(obj.errors[method], '<br />'.html_safe)
      content_tag(:span, errors, class: 'formError')
    else
      ''
    end
  end

  def available_countries
    checkout_zone = Spree::Zone.find_by(name: Spree::Config[:checkout_zone])

    countries = if checkout_zone && checkout_zone.kind == 'country'
                  checkout_zone.country_list
                else
                  Spree::Country.all
                end

    countries.collect do |country|
      country.name = Spree.t(country.iso, scope: 'country_names', default: country.name)
      country
    end.sort_by { |c| c.name.parameterize }
  end

  def display_price(product_or_variant)
    product_or_variant.
      price_in(current_currency).
      display_price_including_vat_for(current_price_options).
      to_html 
  end

  def sale_price(product_or_variant)
    if product_or_variant.is_a?(Spree::Variant)
      v = product_or_variant
    else
      v = product_or_variant.master
    end

    price = display_price(product_or_variant)

    price = Spree::Price.new(
      variant_id: v.id, 
      amount: v.sale_price, 
      currency: current_currency
    ) if v.sale_price?

    price.display_amount.to_html
  end

  def sale_percent(product_or_variant)
    if product_or_variant.is_a?(Spree::Variant)
      v = product_or_variant
    else
      v = product_or_variant.master
    end

    price_orig = v.price_in(current_currency)
    price_sale ||= Spree::Price.new(
      variant_id: v.id, 
      amount: v.sale_price, 
      currency: current_currency
    ) if v.sale_price
    
    100 - ((price_sale.amount.to_f / price_orig.amount.to_f) * 100).round(2)
  end

  def link_to_tracking(shipment, options = {})
    return unless shipment.tracking && shipment.shipping_method

    options[:target] ||= :blank

    if shipment.tracking_url
      link_to(shipment.tracking, shipment.tracking_url, options)
    else
      content_tag(:span, shipment.tracking)
    end
  end

  def logo(image_path = Spree::Config[:logo], options = {})
    path = spree.respond_to?(:root_path) ? spree.root_path : main_app.root_path

    link_to path, 'aria-label': current_store.name, method: options[:method] do
      image_tag image_path, alt: current_store.name, title: current_store.name
    end
  end

  def meta_data
    object = instance_variable_get('@' + controller_name.singularize)
    meta = {}

    if object.is_a? ApplicationRecord
      meta[:keywords] = object.meta_keywords if object[:meta_keywords].present?
      meta[:description] = object.meta_description if object[:meta_description].present?
    end

    if meta[:description].blank? && object.is_a?(Spree::Product)
      meta[:description] = truncate(strip_tags(object.description), length: 160, separator: ' ')
    end

    if meta[:keywords].blank? || meta[:description].blank?
      if object && object[:name].present?
        meta.reverse_merge!(keywords: [object.name, current_store.meta_keywords].reject(&:blank?).join(', '),
                            description: [object.name, current_store.meta_description].reject(&:blank?).join(', '))
      else
        meta.reverse_merge!(keywords: (current_store.meta_keywords || current_store.seo_title),
                            description: (current_store.meta_description || current_store.seo_title))
      end
    end
    meta
  end

  def meta_image_url_path
    object = instance_variable_get('@' + controller_name.singularize)
    return unless object.is_a?(Spree::Product)

    image = default_image_for_product_or_variant(object)
    image&.attachment.present? ? main_app.url_for(image.attachment) : asset_path(Spree::Config[:logo])
  end

  def meta_image_data_tag
    tag('meta', property: 'og:image', content: meta_image_url_path) if meta_image_url_path
  end

  def meta_data_tags
    meta_data.map do |name, content|
      tag('meta', name: name, content: content) unless name.nil? || content.nil?
    end.join("\n")
  end

  def method_missing(method_name, *args, &block)
    if image_style = image_style_from_method_name(method_name)
      define_image_method(image_style)
      send(method_name, *args)
    else
      super
    end
  end

  def pretty_time(time)
    return '' if time.blank?

    [I18n.l(time.to_date, format: :long), time.strftime('%l:%M %p')].join(' ')
  end

  def seo_url(taxon, options = nil)
    spree.nested_taxons_path(taxon.permalink, options)
  end

  def frontend_available?
    Spree::Core::Engine.frontend_available?
  end

  # we should always try to render image of the default variant
  # same as it's done on PDP
  def default_image_for_product(product)
    if product.default_variant.images.any?
      product.default_variant.images.first
    elsif product.variant_images.any?
      product.variant_images.first
    end
  end

  def default_image_for_product_or_variant(product_or_variant)
    Rails.cache.fetch("spree/default-image/#{product_or_variant.cache_key_with_version}") do
      if product_or_variant.is_a?(Spree::Product)
        default_image_for_product(product_or_variant)
      elsif product_or_variant.is_a?(Spree::Variant)
        if product_or_variant.images.any?
          product_or_variant.images.first
        else
          default_image_for_product(product_or_variant.product)
        end
      end
    end
  end

  def base_cache_key
    [I18n.locale, current_currency]
  end

  private

  def create_product_image_tag(image, product, options, style)
    options[:alt] = image.alt.blank? ? product.name : image.alt
    image_tag main_app.url_for(image.url(style)), options
  end

  def define_image_method(style)
    self.class.send :define_method, "#{style}_image" do |product, *options|
      options = options.first || {}
      options[:alt] ||= product.name
      image_path = default_image_for_product_or_variant(product)
      if image_path.present?
        create_product_image_tag image_path, product, options, style
      else
        image_tag "noimage/#{style}.png", options
      end
    end
  end

  # Returns style of image or nil
  def image_style_from_method_name(method_name)
    if method_name.to_s.match(/_image$/) && style = method_name.to_s.sub(/_image$/, '')
      style if style.in? Spree::Image.styles.with_indifferent_access
    end
  end

  def order_time(time)
    return '' if time.blank?

    [I18n.l(time.to_date), time.strftime('%l:%M %p').strip].join(' ')
  end
end
