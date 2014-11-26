class AddUserToProductItems < ActiveRecord::Migration
  def change
    add_reference :product_items, :user, index: true
  end
end
