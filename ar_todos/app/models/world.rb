class World < ActiveRecord::Base

  has_many :squirrels

    def set_world_year
      self.update_attributes(year: 0)
    end

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

  def time_plus
    self.update_attributes(year: self.year + 1)
    make_babies
    challenge = rand(20000)
    self.squirrels.each do |squirrel|
      if squirrel.death_time == nil
        squirrel.survival_check(challenge, self.fitness_hash)
      end
    end


  end

  def make_founders(population=100)
    gene_pool = ("aa".."zz").to_a
    population.times do
      genes = gene_pool.sample(10)
      new_genome = genes.join('')
      self.squirrels.create(genome: new_genome).set_birth_time
    end
  end

  def living_squirrels
    self.squirrels.where(death_time: nil)
  end

  def feed_david
    census = living_squirrels.map{|squirrel| squirrel.genome_list}
    p census
    gene_freq = {}
    census.each do |body|
      body.each do |chrome|
        if gene_freq[chrome]
          gene_freq[chrome]+=1
        else
          gene_freq[chrome] = 1
        end
      end
    end

    sorted_gene = gene_freq.sort_by{| k,v| v}
    # p sorted_gene
    return sorted_gene
  end



  def make_babies(number=100)
    parents = self.squirrels.where(death_time: nil).sample(number*2)
    parents = parents.each_slice(2).to_a
    parents.each do |family|
      break if family.length ==1
      seed0 = family[0].genome_list.sample(5)
      seed1 = family[1].genome_list.sample(5)
      self.squirrels.create(genome: (seed0+seed1).join("")).set_birth_time
    end
  end


end