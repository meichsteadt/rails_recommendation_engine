class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :model
      t.float :order_price
      t.integer :customer_id

      t.timestamps
    end
  end
end
