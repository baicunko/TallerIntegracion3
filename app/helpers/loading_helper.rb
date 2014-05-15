module LoadingHelper
  require 'CSV'

  def self.import()
    #Open file
    file = File.join(Rails.root, 'app', 'products.csv')
	  File.read(file)

    CSV.foreach("#{Rails.root}/app/products.csv", headers: true) do |row|

      product_hash = row.to_hash # exclude the price field
      product = ProductAccess.where(id: product_hash["id"])

      if product.count == 1
        product.first.update_attributes(product_hash.except("price")) # exclude the price field.
      else
        ProductAccess.create!(product_hash)
      end # end if !product.nil?
    end # end CSV.foreach
  end # end self.import(file)
end