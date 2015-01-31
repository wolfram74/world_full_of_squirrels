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


	# FOR THE GRAPHS
	# ================================

	# LARGEST AGE VS GENE
	def longest_age_genes
		temp_all = []
		temp_all = @dead + @alive
		temp_all.sort_by! {|squirrel| squirrel.get_age } 
		the_return = []
		10.times { the_return << temp_all.pop.gene }
		return the_return
	end

	def longest_age_ages
		temp_all = []
		temp_all = @dead + @alive
		temp_all.sort_by! {|squirrel| squirrel.get_age } 
		the_return = []
		10.times { the_return << temp_all.pop.get_age }
		return the_return
	end

	# GENE VS LARGEST COUNT
	def gene_vs_largest_count (count)
		temp_all = []
		temp_all = @dead + @alive

		hash = Hash.new
		temp_all.each do |squirrel|
			if hash.has_key?(squirrel.gene)
				hash[squirrel.gene] += 1
			else
				hash[squirrel.gene] = 1
			end
		end

		hash = hash.sort_by {|_key, value| value}
		
		arr = []
		arr2 = []
		for i in 0..count
			temp_arr = hash.pop
			arr << temp_arr[0] 
			arr2 << temp_arr[1]
		end

		[arr, arr2] 
	end

	def eight_genes_vs_count
		all = @dead + @alive
		gene_list = []
		all.each do |squirrel|
			gene_list << squirrel.gene
		end

		a_cnt = 0
		b_cnt = 0
		c_cnt = 0
		d_cnt = 0
		e_cnt = 0
		f_cnt = 0
		g_cnt = 0
		h_cnt = 0

		gene_list.each do |str|
			if str.index("AA") != nil
				a_cnt += 1
			end
			if str.index("BB") != nil
				b_cnt += 1
			end
			if str.index("CC") != nil
				c_cnt += 1
			end
			if str.index("DD") != nil
				d_cnt += 1
			end
			if str.index("EE") != nil
				e_cnt += 1
			end
			if str.index("FF") != nil
				f_cnt += 1
			end
			if str.index("GG") != nil
				g_cnt += 1
			end
			if str.index("HH") != nil
				h_cnt += 1
			end
		end
		return [a_cnt, b_cnt, c_cnt, d_cnt, e_cnt, f_cnt, g_cnt, h_cnt]
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
	def most_common_gene(count = 200)
		@all = @alive + @dead
		@all.shuffle
	
		
		list = {} 
		puts "AHHHHHHHHHHHH"
		for i in 0..count
			puts "I: #{i}"
			#puts "ALL: #{@all}"
			the_gene= @all[i].gene
			if list[the_gene] == nil
				list[the_gene] = 1
			else
				list[the_gene] += 1
			end
		end
		puts "THE LIST: #{list}"
		list = list.sort_by{|key, value| value}
		puts "="*30

		# limit it 
		puts "AAAAAAAAAAAA #{list.class}"
		the_return1 = []
		the_return2 = []
		keys = list.keys
		vals = list.values
		for i in 0..4
			the_return1 << keys[i]
			the_return2 << vals[i] 
		end
		return [the_return1, the_return2]	
	end

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
			gene_prob += -10 # bad
		end
		if @gene.index("BB") != nil
			gene_prob += -7
		end
		if @gene.index("CC") != nil
			gene_prob += -4
		end
		if @gene.index("DD") != nil
			gene_prob += -3
		end

		# good genes
		if @gene.index("EE")
			gene_prob += 3
		end

		if @gene.index("FF")
			gene_prob += 5
		end

		if @gene.index("GG")
			gene_prob += 7 
		end

		if @gene.index("HH")
			gene_prob += 9
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
manager.seed(500)
manager.start(100)

arr = manager.longest_age_genes
arr2 = manager.longest_age_ages
#puts "arr"
#puts arr
#puts "AAAA"
#puts arr2

arr = manager.gene_vs_largest_count(10)
p arr[0]
p arr[1]

# THIS RETURNS THE ARRAY
p manager.eight_genes_vs_count
