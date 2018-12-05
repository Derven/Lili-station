//this file contents areas and areas processing
#define SUPPLY_STATION_AREATYPE "/area/ship/shuttle_mining" //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE "/area/ship/shuttle_station" //Type of the supply shuttle area for dock

/area
	layer = 1
	name = "Space"

	ship
		luminosity = 0

		deck_1
			name = "test_deck"

		deck_2
			name = "test_deck"

		shuttle_station

		shuttle_mining


/proc/send_supply_shuttle()

	var/shuttleat = supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE
	var/shuttleto = !supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE

	var/area/from = locate(text2path(shuttleat))
	var/area/dest = locate(text2path(shuttleto))

	if(!from || !dest) return

	from.move_contents_to(dest)
	supply_shuttle_at_station = !supply_shuttle_at_station


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