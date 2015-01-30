require_relative "../../config/application"

class CreateSquirrels < ActiveRecord::Migration
  def change
    create_table :squirrels do |t|
      t.string :genome
      t.integer :birth_time
      t.integer :death_time
      t.integer :world_id

      t.timestamps
    end
  end
end