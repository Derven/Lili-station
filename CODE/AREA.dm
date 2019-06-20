//this file contents areas and areas processing
#define SUPPLY_STATION_AREATYPE "/area/ship/shuttle_mining" //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE "/area/ship/shuttle_station" //Type of the supply shuttle area for dock

//area vars
//---------------------
/area/var/sound = null
/area/var/probality = 85
/area/var/has_gravity = 0
/area/var/list/related			// the other areas of the same type as this
/area/var/atmos = 1
/area/layer = 1
/area/name = "Space"
//---------------------

//area procs
//---------------------
/area/New()
	..()
	var/sd_created = 0
	sd_New(sd_created)
	if(sd_created)
		related += src
		return

/area/bullet_act(var/obj/item/projectile/Proj)
	del(Proj)

/area/proc/soundreturn()
	if(!istype(src, /area/lobby))
		return pick('ambigen6.ogg', 'heartbeat.ogg', 'Hullcreak.ogg', 'industrial_suspense1.ogg','ambimo2.ogg', 'industrial_suspense2.ogg', 'ambigen5.ogg', 'ambigen1.ogg','ambigen3.ogg','ambigen4.ogg','ambigen9.ogg','ambigen10.ogg','ambigen11.ogg','ambigen12.ogg')

/area/proc/ambplay(var/mob/A)
	sound = soundreturn()
	if(sound)
		if (prob(probality))
			if(A && A.client && !A.client.played)
				var/sound/S1 = sound(sound, repeat = 0, wait = 0, volume = rand(7, 10), channel = 1)
				S1.environment = 10
				A << S1
				A:client:played = 1
				spawn(650)
					if(A && A.client)
						A:client:played = 0

/area/Entered(mob/A)
	if(istype(A, /mob))
		ambplay(A)

/area/bullet_act(var/obj/item/projectile/Proj)
	del(Proj)

/area/Entered(mob/A)
	if(istype(A, /mob))
		ambplay(A)

//procs(area)
//---------------------
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

/proc/send_supply_shuttle()

	var/shuttleat = supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE
	var/shuttleto = !supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE

	var/area/from = locate(text2path(shuttleat))
	var/area/dest = locate(text2path(shuttleto))

	if(!from || !dest) return

	from.move_contents_to(dest)
	supply_shuttle_at_station = !supply_shuttle_at_station