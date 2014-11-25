class ProductItem < ActiveRecord::Base
  belongs_to :product

  def self.check_in(code)
    product_item = ProductItem.where(code: code).first
    if product_item
      product_item.quantity += 1
      product_item.save
      return product_item
    else
      product = Product.find_by_code(code) || Product.new(code: code, name: 'unknown')
      puts product.name
      product.save! if product.new_record?
      return ProductItem.new({code: code, quantity: 1,last_check_in: Time.now, product: product})
    end
  end
end
