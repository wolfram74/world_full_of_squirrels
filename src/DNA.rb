
# DNA + Base Pairs (although we aren't really using pairs.. )
class DNA_Base
	def type
		return self.class.to_s
	end
end

class Base_A < DNA_Base
	def self.to_str
		"A"
	end
end

class Base_T < DNA_Base
	def self.to_str
		"T"
	end
end

class Base_G < DNA_Base
 	def self.to_str
		"G"
	end
end

class Base_C < DNA_Base
	def self.to_str
		"C"
	end
end


class Squirrel_Manager 
	def initialize
		@alive = []
		@dead = []
		@year = 0
	end

	def seed(count)
		bases = [Base_A, Base_G, Base_C, Base_T]
		for i in 0..count
			#make a gene
			gene = []
			for i in 0..9
				gene << bases.sample
			end
			@alive << Squirrel.new(Gene.new(gene))
		end
	end

	def print_dead
		@dead.each {|squirrel| puts squirrel.to_s}
	end

	def print_alive
		@alive.each {|squirrel| puts squirrel.to_s}
	end

	def breed_squirrel
		squirrels = @alive.shuffle
		squirrels.each_with_index do |squirrel, index|
			num = rand(10) 
			breed = (num == 0) # 1 in 4 chance to breed
			if breed
				new_gene = squirrel.gene.crossover(squirrels[index-1].gene)	
				@alive << Squirrel.new(new_gene)
				squirrels.delete_at(index)
				squirrels.delete_at(index-1)
			end
		end
	end

	def increment_year
		@year += 1
		puts "IT is now year #{@year}"
		@alive.each do |squirrel|
#			puts "Going thru squirrel"
			squirrel.age
#			puts "Aging.."
			if !squirrel.alive
#				puts "OH NO! A squirrel died: "
#				puts squirrel.to_s
				@dead << squirrel
				@alive.delete(squirrel)
			end
		end
		breed_squirrel
	end

	def start(years)
		for i in 0..years
			increment_year
#			sleep 0.15
		end
	
		#@all = @alive + @dead
		@all = @dead
		#puts @all
		puts "SQUIRREL CNT: #{@all.count}"
		puts "TOP 10 BEST SQUIRRELS:"
		@all.sort_by! {|squirrel| squirrel.get_age } 
		10.times { puts @all.pop.to_s }

		puts "=" * 50
		puts "TOP 10 WORST SQUIRRELS"
		@all.reverse!
		10.times {puts @all.pop.to_s }

	end
end


class Squirrel
	@@count = 0
	attr_reader :gene, :alive, :age
	def initialize (gene)
		@id = @@count
		@@count += 1
		@gene = gene
		@age = 0
		@alive = true
	end

	def get_age
		@age
	end

	def age
		@age += 1
		check_death()
	end	

	def die
		@alive = false
	end

	def check_death
		gene_str = @gene.to_s
		gene_prob = 0
		if gene_str.include? "AAA" 
			gene_prob = 45 # bad
		elsif gene_str.include? "GGG"
			gene_prob = 62 #rly bad
		elsif gene_str.include? "TTT"
			gene_prob = -25 #good
		elsif gene_str.include? "CCC"
			gene_prob = 52 #bad
		end

#		puts "Checking death.."

		survival_probabilty = 25.0 / (25.0 + @age + gene_prob) 
		survival_probabilty = 1 if survival_probabilty > 1
		survival_probabilty = 1 if survival_probabilty < 0
		if rand() > survival_probabilty
			die()
		end
	end
	
	def to_s
		"Squirrel #{@id}
		Age: #{@age}
		Alive: #{@alive}
		Gene: #{@gene.to_s}\n"
	end
end

class Gene

	def to_s
		str = ""
		@bases.each {|base| str << base.to_str}
		str
	end

	# init. with array lf 10 DNA_Bases
	def initialize(bases)
		@bases = bases
	end

	def at (ind)
		@bases[ind]
	end

	# missense mutation - change a base, randomly
	def mutate
		index = rand(0..9) # pick the location of a base
        base = [Base_A, Base_T, Base_G, Base_C] 
		base = base - [@bases[index]] # must choose a new base
		base_index = rand(0..2)
		@bases[index] = base[base_index] #mutate
	end

	# returns new gene of cross over
	def crossover (bases2)
		new_base = []
		for i in (0..9)
			if rand(0..1)  == 0
				new_base << @bases[i]
			else
				new_base << bases2.at(i)
			end
		end

		new_gene = Gene.new(new_base)
		if rand(0..24) == 0
#			puts "MUTATE!"
			new_gene.mutate
		end
		new_gene
	end		
end







manager = Squirrel_Manager.new
manager.seed(25)
manager.start(100)
