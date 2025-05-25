class CreateWars < ActiveRecord::Migration[7.1]
  def change
    create_table :wars do |t|
      t.string :name
      t.string :first_belligerents
      t.string :second_belligerents
      t.string :number
      t.integer :first_year
      t.integer :last_year
      t.string :who_win
      t.string :name_of_the_peace_treaty

      t.timestamps
    end
  end
end
