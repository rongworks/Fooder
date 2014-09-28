class CreateProductItems < ActiveRecord::Migration
  def change
    create_table :product_items do |t|
      t.string :code, index: true
      t.integer :quantity
      t.datetime :last_check_in
      t.datetime :last_checkout

      t.timestamps
    end
  end
end
