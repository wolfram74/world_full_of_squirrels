class Squirrel
	# Properties:
	# int birthday
	# int deathday [nil]
	# int id
	# str chromosomes

	attr_reader :birthday, :deathday, :id, :chromosomes
	def initialize (args)
		@birthday = args[:birthday]
		@id = args[:id]
		@chromosomes = args[:chromosomes]
		@deathday = nil
	end

	def to_s
		"Squirrel " + id.to_s + "\n" +
		"Age: " + (birthday).to_s + "\n" +
		"Alive: " + (deathday == nil ? "Yes" : "No") + "\n" +
		"Chromosomes: " + chromosomes.to_s + "\n\n"
	end

	# TODO: get_age
	def get_age 
		# query the databse for the world's current year 
		query = 0 # should actually come from the world...
		return query - birthday
	end



	# From world, I get an a hash containing a key, value pair as such:
	# key: array (of two letter strings) 
	# value: genetic constant boost 
	# input: hash of good/bad genes
	def death_chance (world_genes)
		# Formula:
		#             100 
		# ___________________________
		# (100 + age - gene constant)
		
		# If gene constant = 0, squirrel has a50% chance of dying
		# around age 11-12

		# Calculate the gene constant
		gene_constant = 0
		world_genes.each do |key, value|
			# key is the array
			has_sequence = true 
			key.each do |chromesome_pair|
				# check if the squirrel has pair
				if @chromesomes.index(chromosome_pair) == nil
					has_sequence = false
				end
			end

			gene_constant += value if has_sequence
		end
		
		# Create max and min bound for gene constnat
		if gene_constant < 0
			gene_constant = 0
		elsif gene_constant > 100 
			gene_constant = 100 # can change if we want ofc
		end

		# get the age

		death_probabilty = 100 / (100 + get_age + gene_constant)
		puts "Probability of death: " + death_probability 
		return death_probabilty
	end
end

def create_new_chromosomes (chr1, chr2)
	final_chromes = ""
	ch1 = String.new(chr1)
	ch2 = String.new(chr2)

	# add each chromosome to total_chromes
	for i in 0..9
		num = rand(0..2)
		
		chrome1 = ch1.slice!(0..1)
		chrome2 = ch2.slice!(0..1)

		if num == 0
			final_chromes += chrome1
		else
			final_chromes += chrome2
		end
	end

	final_chromes
end




#TESTS
puts "TESTING CREATING NEW CHROMOSOMES"
chrome1 = "A" * 20
chrome2 = "B" * 20

chromes_1_2 = create_new_chromosomes(chrome1, chrome2)
p chromes_1_2.index(/[^A^B]/) == nil
p chromes_1_2.index(/[AB]{20}/) != nil 


chrome3 = "ABBCCDDEEFFGGHHIIJJK"
chromes_1_3 = create_new_chromosomes(chrome3, chrome1)
p chromes_1_3.index(/[^[A-K]]/) == nil
p chromes_1_3.index(/[A-K]{20}/) != nil

puts "CHROME1: #{chrome1}\nCHROME3: #{chrome3}\n#{chromes_1_3}"


puts "TESTING THE SQUIRRELS"
sq1 = Squirrel.new({birthday: 0, id: 1, chromosomes: chrome1, deathday: nil})
puts sq1.to_s
