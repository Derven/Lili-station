/area
	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	layer = 1
	level = null
	name = "Space"
	layer = 10
	mouse_opacity = 0
	var/lightswitch = 1

	var/area_lights_luminosity = 9	//This gets assigned at area creation. It is used to determine how bright the lights in an area should be. At the time of writing the value that it gets assigned is rand(6,9) - only used for light tubes

	var/eject = null

	var/requires_power = 1
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()
	var/power_equip = 0
	var/power_light = 0
	var/power_environ = 0
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0


	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
	var/list/lights				//

	ship
		luminosity = 0

		deck_1

		deck_2

/area/New()
	master = src
	related = list(src)

/area/proc/poweralert(var/state, var/source)
	return

/area/proc/usage(var/chan)
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += master.used_light
		if(EQUIP)
			used += master.used_equip
		if(ENVIRON)
			used += master.used_environ
		if(TOTAL)
			used += master.used_light + master.used_equip + master.used_environ

	return used

/area/proc/clear_usage()

	master.used_equip = 0
	master.used_light = 0
	master.used_environ = 0

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

/area/
	var/global/global_uid = 0
	var/uid