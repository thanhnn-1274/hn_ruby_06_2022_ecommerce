class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2
      t.integer :page_num
      t.string :image
      t.string :publisher_name
      t.integer :quantity
      t.decimal :rate_avg, precision: 2, scale: 1
      t.text :description

      t.references :category, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
