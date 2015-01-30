class World < ActiveRecord::Base

  has_many :squirrels

    def fitness_hash
      exprs = /((?:\w{2}+?))([pm])(\d+)/
      test =  self.fitness
      parsed = test.scan(exprs)
      fitness_hash = {}
      parsed.each do |genome|
      key = genome[0].chars.each_slice(2).map(&:join)
      value = genome[2].to_i
      value *= -1 if genome[1] == "m"
      fitness_hash[key]= value
    end
    fitness_hash
  end

  def make_babies(number)
    parents = self.squirrels.where(death_time: nil).sample(number*2)
    parents = parents.each_slice(2).to_a
    parents.each do |family|
      p family
      break if family.length ==1
      seed0 = family[0].genome_list.sample(5)
      seed1 = family[1].genome_list.sample(5)
      self.squirrels.create(genome: (seed0+seed1).join("")).set_birth_time
    end
  end


end