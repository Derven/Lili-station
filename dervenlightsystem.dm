/atom

	var
		//fucked shame
		var/turf/simulated/floor/NORTHTURF
		var/turf/simulated/floor/SOUTHTURF
		var/turf/simulated/floor/WESTTURF
		var/turf/simulated/floor/EASTTURF
		var/turf/simulated/floor/CENTERTURF
		var/turf/simulated/floor/SOUTHEASTTURF
		var/turf/simulated/floor/SOUTHWESTTURF
		var/turf/simulated/floor/NORTHWESTTURF
		var/turf/simulated/floor/NORTHEASTTURF
		//fucked shame

	proc/init_turf()
		NORTHTURF = get_step(src, NORTH)
		SOUTHTURF = get_step(src, SOUTH)
		WESTTURF = get_step(src, WEST)
		EASTTURF = get_step(src, EAST)
		CENTERTURF = src.loc
		SOUTHEASTTURF = get_step(src, SOUTHEAST)
		SOUTHWESTTURF = get_step(src, SOUTHWEST)
		NORTHWESTTURF = get_step(src, NORTHWEST)
		NORTHEASTTURF = get_step(src, NORTHEAST)

/atom
	var
		lightcapacity = 0

proc/global_turf_init()
	spawn(1)
	for(var/obj/machinery/lamp/O in world)
		O.init_turf()


/obj/proc/dark()
	for(var/turf/L in range(6,src))
		L.lightcapacity = 0
		L.mylightcolor()
	for(var/obj/L in range(6,src))
		L.lightcapacity = 0
		L.mylightcolor()

/obj/proc/part_of(var/turf/where)
	where.lightcapacity = 5
	for(var/turf/LI in view(6,where))
		switch(get_dist(LI,where))
			if(1)
				LI.lightcapacity = 5
				LI.mylightcolor()
			if(2)
				LI.lightcapacity = 5
				LI.mylightcolor()
			if(3)
				if(LI.lightcapacity > 4)
					LI.lightcapacity = LI.lightcapacity
					LI.mylightcolor()
				else
					LI.lightcapacity = 4
					LI.mylightcolor()
			if(4)
				if(LI.lightcapacity > 3)
					LI.lightcapacity = LI.lightcapacity
					LI.mylightcolor()
				else
					LI.lightcapacity = 3
					LI.mylightcolor()
			if(5)
				if(LI.lightcapacity > 2)
					LI.lightcapacity = LI.lightcapacity
					LI.mylightcolor()
				else
					LI.lightcapacity = 2
					LI.mylightcolor()
			else
				if(LI.lightcapacity > 1)
					LI.lightcapacity = LI.lightcapacity
					LI.mylightcolor()
				else
					LI.lightcapacity = 1
					LI.mylightcolor()

	for(var/obj/LI in view(6,where))
		switch(get_dist(LI,where))
			if(1)
				LI.lightcapacity = 5
				LI.mylightcolor()
			if(2)
				LI.lightcapacity = 5
				LI.mylightcolor()
			if(3)
				if(LI.lightcapacity > 4)
					LI.lightcapacity = LI.lightcapacity
					LI.mylightcolor()
				else
					LI.lightcapacity = 4
					LI.mylightcolor()
			if(4)
				if(LI.lightcapacity > 3)
					LI.lightcapacity = LI.lightcapacity
					LI.mylightcolor()
				else
					LI.lightcapacity = 3
					LI.mylightcolor()
			if(5)
				if(LI.lightcapacity > 2)
					LI.lightcapacity = LI.lightcapacity
					LI.mylightcolor()
				else
					LI.lightcapacity = 2
					LI.mylightcolor()
			else
				if(LI.lightcapacity > 1)
					LI.lightcapacity = LI.lightcapacity
					LI.mylightcolor()
				else
					LI.lightcapacity = 1
					LI.mylightcolor()

				//if(LIGHTEX.lightcapacity < 4)
				//	LIGHTEX.lightcapacity = 3
				//	LIGHTEX.mylightcolor()

/obj/proc/lumina()
	part_of(NORTHTURF)
	part_of(SOUTHTURF)
	part_of(WESTTURF)
	part_of(EASTTURF)
	part_of(CENTERTURF)

	for(var/turf/L in CENTERTURF)
		L.lightcapacity = 4

/atom
	proc/mylightcolor()
		if(!(istype(src, /turf/space)))
			if(lightcapacity < 0)
				lightcapacity = 0
			switch(lightcapacity)
				if(0)
					color = "#a0a09f"
				if(1)
					color = "#a3a3a1"
				if(2)
					color = "#cccccc"
				if(3)
					color = "#dbdbd9"
				if(4)
					color = "#f2f2ef"
				else
					color = null

proc/my_light()
	spawn(5)
		for(var/turf/simulated/A in world)
			A.mylightcolor()

