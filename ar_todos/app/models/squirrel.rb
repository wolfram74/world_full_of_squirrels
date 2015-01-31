class Squirrel < ActiveRecord::Base

  belongs_to :world

  def set_birth_time
    self.update_attributes(birth_time: self.world.year)
  end

  def dies!
    self.update_attributes(death_time: self.world.year)
  end

  def survival_check(challenge, fitness_hash)
    base = 17000
    fitness_hash.each do |key, value|
      has = true
      key.each do |string|
        has = has && self.genome_list.include?(string)
      end
      base += value if has
    end
    dies! if base < challenge
  end

  def age
    self.world.year - self.birth_time
  end

  def genome_list
    self.genome.chars.each_slice(2).to_a.map{ |el| el.join('') }
  end


end