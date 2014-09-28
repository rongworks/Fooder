class AddProductIdToProductItems < ActiveRecord::Migration
  def change
    add_reference :product_items, :product, index: true
  end
end
