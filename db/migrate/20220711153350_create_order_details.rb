class CreateOrderDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :order_details do |t|
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity
      t.decimal :total_money, default: 0, precision: 10, scale: 2
      t.references :book, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
