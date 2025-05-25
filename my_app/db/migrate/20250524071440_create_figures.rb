class CreateFigures < ActiveRecord::Migration[7.1]
  def change
    create_table :figures do |t|
      t.string :first_name
      t.string :last_name
      t.string :number
      t.integer :birth_year
      t.integer :death_year
      t.string :occupation

      t.timestamps
    end
  end
end
