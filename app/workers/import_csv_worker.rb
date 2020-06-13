require 'csv'
require "open-uri"

class ImportCsvWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, file_id)
    
    file = Spree::User.find(user_id).csv_files.find(file_id).download.force_encoding('UTF-8')
    rowcount = 0
    
    CSV.parse(file, headers: true) do |row|

      product = Spree::Product.create!(
        shipping_category: Spree::ShippingCategory.first,
        tax_category: Spree::TaxCategory.first,
        slug: row[0].downcase.gsub(/[!@%&"]/,'') + "#{rand(1..2000010)}",
        sku: row[1].split(" ").join("-") + "#{rand(1..10000010)}",
        available_on: DateTime.now,
        currency: "PLN",
        description: row[5],
        price: Money.new(0),
        name: row[0]
      )

      puts product.name
      
      begin
        row[2].to_s.split(", ").each do |tax|
          taxon = Spree::Taxon.find_or_create_by(name: tax)
          product.taxons << taxon      
        end
      rescue ActiveRecord::RecordInvalid => e
      end

      begin
        uri = row[3]
        uri = "https://via.placeholder.com/140x100" if row[3].to_s.strip.empty?
        read_image = URI.open(uri) 
      rescue OpenURI::HTTPError => ex
        read_image = nil
      end
      if read_image
        image = Spree::Image.new(attachment:{io: read_image, filename: "#{rand(1..210)}.jpg"})
        product.images << image if image
      end
    end
  end
end
