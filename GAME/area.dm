//this file contents areas and areas processing
/area
	layer = 1
	name = "Space"

	ship
		luminosity = 0

		deck_1
			name = "test_deck"

		deck_2
			name = "test_deck"

///AREAS///
/proc/get_area_name(N) //get area by it's name
	for(var/area/A in world)
		if(A.name == N)
			return A
	return 0


/proc/get_area(O)
	var/atom/location = O
	var/i
	for(i=1, i<=20, i++)
		if(isarea(location))
			return location
		else if (istype(location))
			location = location.loc
		else
			return null
	return 0
///AREAS///