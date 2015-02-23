class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :course
      t.string :section
      t.time :start
      t.time :end
      t.string :day
      t.string :instructor
      t.timestamps
    end

  end
end
