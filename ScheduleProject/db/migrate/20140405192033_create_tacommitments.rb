class CreateTacommitments < ActiveRecord::Migration
  def change
    create_table :tacommitments do |t|
      t.string :name
      t.string :commitments
     
      t.timestamps
    end
  end
end
