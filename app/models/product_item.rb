class ProductItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :user

  validates_presence_of :code, :user_id

  def self.check_in(code, user_id)
    product_item = ProductItem.where(code: code, user_id: user_id).first
    if product_item
      product_item.quantity += 1
      product_item.last_check_in= Time.now
      if product_item.save
        return product_item
      else
        return nil
      end
    else
      product = Product.find_by_code(code) || Product.new(code: code, name: 'unknown')
      puts product.name
      product.save! if product.new_record?
      return ProductItem.new({code: code, quantity: 1,last_check_in: Time.now, product_id: product.id, user_id: user_id})
    end
  end

  def self.check_out(code, user_id)
    product_item = ProductItem.where(code: code, user_id: user_id).first || nil
    if product_item
      product_item.quantity -= 1
      product_item.last_checkout= Time.now
      if product_item.save
        return product_item
      else
        return nil
      end
    else
      return nil
    end
  end
end
