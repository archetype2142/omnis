cache [I18n.locale, @current_user_roles.include?('admin'), 'small_variant', root_object]

attributes *variant_attributes
node(:price) { |p| p.prices.find_by(price_book: @user.price_book) }
# node(:options_text, &:options_text)
# node(:track_inventory, &:should_track_inventory?)
# node(:in_stock, &:in_stock?)
# node(:is_backorderable, &:is_backorderable?)
# node(:is_orderable) { |v| v.is_backorderable? || v.in_stock? }
# node(:total_on_hand, &:total_on_hand)
# node(:is_destroyed, &:destroyed?)
