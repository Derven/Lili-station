#define TRAIN 545

/dz
	parent_type = /obj //zone for moving multitile transport
	icon = 'floors.dmi'
	icon_state = "shuttle"
	anchored = 1
	var
		id //id of transport
		center = 0
		curdir = "north" //west, south, east
		list/obj/partslist = list()
	layer = 1

	train
		id = TRAIN

		verb/back()
			set src in range(1, usr)
			for(var/dz/DZ in world)
				if(DZ.id == id)
					DZ.rotate180()
			drive_my_car()
			for(var/dz/DZ in world)
				if(DZ.id == id)
					DZ.rotate180()

	New()
		..()
		spawn(5)
			for(var/atom/movable/O in range(2, src))
				spawn(1)
					partslist.Add(O)

	proc/mdr()
		if(curdir == "north")
			curdir = "west"
			return

		if(curdir == "west")
			curdir = "south"
			return

		if(curdir == "south")
			curdir = "east"
			return

		if(curdir == "east")
			curdir = "north"
			return

	proc/rotate180()
		if(curdir == "north")
			curdir = "south"
			return

		if(curdir == "south")
			curdir = "north"
			return

	proc/rotate_me(cx, cy)
		for(var/atom/movable/M in loc)
			M.rotate_(cx, cy)

	verb/rotate_my_car()
		set src in range(1, usr)
		if(!istype(src, /dz/train))
			var/center_x
			var/center_y

			for(var/dz/DZ in world)
				if(DZ.id == id && DZ.center == 1)
					center_x = DZ.x
					center_y = DZ.y

			for(var/dz/DZ in world)
				if(DZ.id == id)
					DZ.rotate_me(center_x, center_y)
					DZ.mdr()

	verb/drive()
		set src in range(1, usr)
		drive_my_car()


	proc/drive_my_car()
		for(var/dz/DZ in world)
			if(DZ.id == id)
				if(DZ.CHECK(DZ.curdir) == 333)
					return

		for(var/dz/DZ in world)
			if(DZ.id == id)
				for(var/atom/movable/M in DZ.loc)
					M.MOVETO(DZ.curdir, DZ.partslist)

/atom/movable
	proc/rotate_(cx, cy)
		spawn(2)
			loc = locate(cx + (x - cx) * cos(90) - (y - cy) * sin(90), cy + (y - cy) * cos(90) + (x - cx) * sin(90), z)

	proc/MOVETO(var/curdir, var/list/obj/partslist)
		spawn(2)
			if(curdir == "north")
				if(!istype(locate(x, y + 1, z), /turf/simulated/wall))
					for(var/obj/O in locate(x, y + 1, z))
						if(!(partslist.Find(O)))
							O.deconstruct()
					loc = locate(x, y + 1, z)
			if(curdir == "south")
				if(!istype(locate(x, y - 1, z), /turf/simulated/wall))
					loc = locate(x, y - 1, z)
					for(var/obj/O in locate(x, y - 1, z))
						if(!(partslist.Find(O)))
							O.deconstruct()

			if(curdir == "west")
				if(!istype(locate(x - 1, y, z), /turf/simulated/wall))
					loc = locate(x - 1, y, z)
					for(var/obj/O in locate(x - 1, y, z))
						if(!(partslist.Find(O)))
							O.deconstruct()

			if(curdir == "east")
				if(!istype(locate(x + 1, y, z), /turf/simulated/wall))
					loc = locate(x + 1, y, z)
					for(var/obj/O in locate(x + 1, y, z))
						if(!(partslist.Find(O)))
							O.deconstruct()

	proc/CHECK(var/curdir)
		if(curdir == "north")
			if(istype(locate(x, y + 1, z), /turf/simulated/wall))
				return 333

		if(curdir == "south")
			if(istype(locate(x, y - 1, z), /turf/simulated/wall))
				return 333

		if(curdir == "west")
			if(istype(locate(x - 1, y, z), /turf/simulated/wall))
				return 333

		if(curdir == "east")
			if(istype(locate(x + 1, y, z), /turf/simulated/wall))
				return 333

//X = x0 + (x - x0) * cos(a) - (y - y0) * sin(a);
//Y = y0 + (y - y0) * cos(a) + (x - x0) * sin(a);
//(x0, y0) — center