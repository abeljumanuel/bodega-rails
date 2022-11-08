class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.text :name
      t.text :reference
      t.text :description

      t.timestamps
    end
  end
end
