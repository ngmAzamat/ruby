class CreateCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.integer :first_year
      t.integer :last_year
      t.integer :army
      t.integer :area
      t.integer :population

      t.timestamps
    end
  end
end
