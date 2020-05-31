# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Spree::Core::Engine.load_seed if defined?(Spree::Core)
# Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Spree::TaxCategory.all.destroy_all
Spree::ShippingCategory.all.destroy_all
Spree::Address.all.destroy_all
Spree::User.all.destroy_all
Spree::Product.all.destroy_all
Spree::Country.all.destroy_all
Spree::Role.all.destroy_all
Spree::Zone.all.destroy_all
Spree::StockLocation.all.destroy_all
Spree::StockItem.all.destroy_all

Spree::Zone.create!(name: 'Poland', default_tax: true)
# c = Spree::Country.create!(name: "Poland", iso: "PL", iso3: "POL", iso_name: "Poland")
# poland_sates = %w[dolnośląskie kujawsko-pomorskie lubelskie lubuskie łódzkie 
#                   małopolskie mazowieckie opolskie podkarpackie podlaskie 
#                   pomorskie śląskie świętokrzyskie warmińsko-mazurskie 
#                   wielkopolskie zachodniopomorskie ]
# poland_sates.each do |state|
#   c.states << Spree::State.new(name: state)
# end

u = Spree::User.create!(email: 'test@test.com', password: 'test123')

tax_category = Spree::TaxCategory.create!(name: "24% VAT")
shipping_category = Spree::ShippingCategory.create!(name: "Free Shipping!")

# %w[person company].each { |r| Role.create!(name: r) }
loc = Spree::StockLocation.create!(name: 'Warehouse')


i = File.open(Rails.root.join('app', 'assets', 'images', 'sample.jpeg'))
image = Spree::Image.new(attachment:{io: i, filename: "#{rand(1..210)}.jpg"})

(1..50).each do |user|
  prod = Spree::Product.create!(
    price: Money.new((10000..50000).to_a.sample),
    name: "#{[*?A..?Z].sample( 2 ).join}#{rand 100..999}", 
    tax_category: tax_category,
    shipping_category: shipping_category,
    slug: SecureRandom.hex[8..12],
    sku: SecureRandom.hex[1..5],
    available_on: DateTime.now,
    currency: "PLN"
  )
  prod.images << image

  random = SecureRandom.hex
  
  user = Spree::User.create!(
    email: "#{random[0..5]}@#{random[5..10]}.com", 
    password: "test123",
    client_type: rand(0..1)
  )

  # user.roles << Role.all.sample
  user.addresses.create!(
    user: user,
    country: Spree::Country.last,
    city: "Warzawa",
    address1: "abc",
    firstname: "#{[*?A..?Z].sample( 2 ).join}#{rand 100..999}",
    lastname: "#{[*?A..?Z].sample( 2 ).join}#{rand 100..999}",
    zipcode: '00-631',
    phone: '+4857751111'
  )
end
