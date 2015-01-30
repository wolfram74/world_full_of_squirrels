__END__

--broad strokes
we have a bunch of squirrels at T=0
every time increment, the squirrels pair up and make another squirrel based on their genes
after new squirrels are born, some squirrels die (probability of death is very flexible and has much room for playing)
we iterate over time and afterwards have a bunch of squirrels


database structure:
squirrels
and
worlds



squirrels have an id, a genome, a birth time and a death time, world_id

squirrel class


worlds have an id, perhaps a description about the experiment, and a collection of selection pressures.
