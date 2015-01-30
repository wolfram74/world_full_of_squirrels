require_relative "../../config/application"

class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.string :description
      t.string :fitness
      t.integer :year

      t.timestamps
    end
  end
end
