//this file contents areas and areas processing
#define SUPPLY_STATION_AREATYPE "/area/ship/shuttle_mining" //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE "/area/ship/shuttle_station" //Type of the supply shuttle area for dock

/area
	layer = 1
	name = "Space"
	var/sound = null
	var/probality = 85

	bullet_act(var/obj/item/projectile/Proj)
		del(Proj)

	proc/soundreturn()
		return pick('space1.ogg','space2.ogg', 'space3.ogg', 'rick.ogg')

	proc/ambplay(var/mob/A)
		sound = soundreturn()

		if (prob(probality))
			if(A && A.client && !A.client.played)
				var/sound/S1 = sound(sound, repeat = 0, wait = 0, volume = rand(7, 10), channel = 1)
				S1.environment = 10
				A << S1
				A:client:played = 1
				spawn(650)
					if(A && A.client)
						A:client:played = 0

	Entered(mob/A)
		if(istype(A, /mob))
			ambplay(A)

	lobby
		Entered(mob/A)
			return

	ship
		luminosity = 0
		var/atmos = 1

		deck_1
			name = "test_deck"
			probality = 45
			icon = 'area.dmi'
			color = "blue"
			invisibility = 101

			soundreturn()
				return pick('rick.ogg', 'ambigen6.ogg', 'Hullcreak.ogg', 'industrial_suspense1.ogg', 'industrial_suspense2.ogg', 'ambigen5.ogg', 'ambigen1.ogg','ambigen3.ogg','station4.ogg','ambigen4.ogg','station6.ogg','ambigen9.ogg','ambigen10.ogg','ambigen11.ogg','ambigen12.ogg')

			hallway

			medbay

			geen

		deck_2
			icon = 'area.dmi'
			name = "test_deck"
			color = "blue"

		shuttle_station
			icon = 'area.dmi'
			color = "red"
			invisibility = 101

		shuttle_mining
			icon = 'area.dmi'
			color = "green"
			invisibility = 101




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