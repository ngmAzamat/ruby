class CreateBattles < ActiveRecord::Migration[7.1]
  def change
    create_table :battles do |t|
      t.string :name
      t.string :number
      t.string :first_belligerents
      t.string :second_belligerents
      t.date :date
      t.string :who_win
      t.string :army_of_first_belligerents
      t.string :army_of_second_belligerents

      t.timestamps
    end
  end
end
