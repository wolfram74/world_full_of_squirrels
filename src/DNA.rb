class Squirrel_Manager 
	def initialize
		@alive = []
		@dead = []
		@year = 0
	end

	def seed(count)
		bases = ("A".."Z").to_a 
		for i in 0..count
			#make a gene
			gene = "" 
			for i in 0..9
				gene += bases.sample
			end
			@alive << Squirrel.new(gene)
		end
		puts "ALIVE:"
		puts @alive
	end

	def print_dead
		puts "DEAD SQUIRRELS CNT: #{@dead.length}"
		@dead.each {|squirrel| puts squirrel.to_s}
	end

	def print_alive
		puts "ALIVE SQUIRRELS CNT: #{@alive.length}"
		@alive.each {|squirrel| puts squirrel.to_s}
	end

	def breed_squirrel
		squirrels = @alive.shuffle
		squirrels.each_with_index do |squirrel, index|
			num = rand(10) 
			breed = (num == 0) # 1 in 4 chance to breed
			if breed
				new_gene = squirrel.crossover(squirrels[index-1].gene)	
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
		puts "SQUIRREL CNT: #{@alive.count + @dead.count}"
		puts "TOP 10 BEST SQUIRRELS:"
		@all.sort_by! {|squirrel| squirrel.get_age } 
		10.times { puts @all.pop.to_s }

		puts "=" * 50
		puts "TOP 10 WORST SQUIRRELS"
		@all.reverse!
		10.times {puts @all.pop.to_s }

		#print_alive
		#print_dead
	end


	# default count is 200
	def give_nested_list(count = 200)
		@all = @dead + @alive
		@all.shuffle

		@list = []
		for i in 0..count
			@list << @all[i].gene
		end
		@list
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
		gene_prob = 0
		gene = @gene

		#Bad genes
		if @gene.index("AA") != nil
			gene_prob += -15 # bad
		end
		if @gene.index("BB") != nil
			gene_prob += -20
		end
		if @gene.index("CC") != nil
			gene_prob += -10
		end
		if @gene.index("DD") != nil
			gene_prob += -5
		end

		# good genes
		if @gene.index("EE")
			gene_prob += 10
		end

		if @gene.index("FF")
			gene_prob += 15
		end

		if @gene.index("GG")
			gene_prob += 25 
		end

		if @gene.index("HH")
			gene_prob += 50
		end

#		puts "Checking death.."

		survival_probabilty = 25.0 / (25.0 + @age - gene_prob)
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


	def crossover (bases2)
		new_base = ""
		for i in (0..9)
			if rand(0..1)  == 0
				new_base << gene[i]
			else
				new_base << bases2[i]
			end
		end
		new_base	
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
        base = ["A".."Z"]
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
manager.start(120)

puts manager.give_nested_list(200)
