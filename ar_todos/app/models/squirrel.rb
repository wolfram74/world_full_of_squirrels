class Squirrel < ActiveRecord::Base

  belongs_to :world

  def set_birth_time
    self.update_attributes(birth_time: self.world.year)
  end

  def dies!
    self.update_attributes(death_time: self.world.year)
  end

  def age
    self.world.year - self.birth_time
  end

  def genome_list
    self.genome.chars.each_slice(2).to_a.map{ |el| el.join('') }
  end


end