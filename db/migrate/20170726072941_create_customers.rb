class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.integer :total_sales
      
      t.timestamps
    end
  end
end
