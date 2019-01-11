#define TRAIN 545

/dz
	parent_type = /obj //zone for moving multitile transport
	icon = 'floors.dmi'
	icon_state = "shuttle"
	anchored = 1
	var
		id //id of transport
		center = 0
		curdir = "east" //west, south, east
		list/obj/partslist = list()
	layer = 1

	Crossed(O)
		if(center == 1)
			if(istype(O, /mob/simulated/living/humanoid))
				var/mob/simulated/living/humanoid/H = O
				H.DRV.invisibility = 0
				H.RTT.invisibility = 0

	Uncrossed(O)
		if(center == 1)
			if(istype(O, /mob/simulated/living/humanoid))
				var/mob/simulated/living/humanoid/H = O
				H.DRV.invisibility = 101
				H.RTT.invisibility = 101
	train
		id = TRAIN
		curdir = "west"

		verb/back()
			set src in range(1, usr)
			for(var/dz/train/T in range(8, src))
				T.curdir = "east"
			drive_my_car()
			for(var/dz/train/T in range(8, src))
				T.curdir = "west"

	New()
		..()
		spawn(5)
			icon_state = null
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

	proc/engine()
		for(var/obj/machinery/ionengine/I in world)
			if(I.id == id)
				if(I.use_engine())
					return 1
				else
					return 0
		return 0

	proc/rotate180()
		if(curdir == "north")
			curdir = "south"
			return

		if(curdir == "south")
			curdir = "north"
			return

	proc/rotate_me(cx, cy)
		var/turf/T = loc
		if(T.density == 1)
			boom(rand(2,3), loc)
			if(prob(30))
				for(var/obj/machinery/ionengine/I in world)
					if(I.id == id)
						del(I)
			del(src)
		for(var/atom/movable/M in loc)
			M.rotate_(cx, cy)

	proc/rotate_my_car()
		if(engine())
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

	//verb/drive()
	//	set src in range(1, usr)
	//	drive_my_car()


	proc/drive_my_car()
		for(var/dz/DZ in world)
			if(DZ.id == id)
				if(DZ.CHECK(DZ.curdir, DZ.id) == 333)
					return
		if(engine())
			for(var/dz/DZ in world)
				if(DZ.id == id)
					for(var/atom/movable/M in DZ.loc)
						M.check_max()
						M.MOVETO(DZ.curdir, DZ.id, DZ.partslist)
						var/turf/T = M.loc
						if(T.density == 1)
							boom(rand(2,3), M.loc)

/atom/movable
	proc/rotate_(cx, cy)
		spawn(2)
			dir = turn(dir, 90)
			loc = locate(cx + (x - cx) * cos(90) - (y - cy) * sin(90), cy + (y - cy) * cos(90) + (x - cx) * sin(90), z)


	proc/MOVETO(var/curdir, var/id, var/list/obj/partslist)
		spawn(2)
			if(curdir == "north")
				if(!istype(locate(x, y + 1, z), /turf/simulated/wall))
					for(var/obj/O in locate(x, y + 1, z))
						if(istype(O, /dz))
							var/dz/DZ1221 = O
							if(DZ1221.id != id)
								boom(rand(2,3), O.loc)
						if(!(partslist.Find(O)))
							O.deconstruct()
					loc = locate(x, y + 1, z)
				else
					if(prob(25))
						boom(rand(2,3), loc)

			if(curdir == "south")
				if(!istype(locate(x, y - 1, z), /turf/simulated/wall))
					loc = locate(x, y - 1, z)
					for(var/obj/O in locate(x, y - 1, z))
						if(istype(O, /dz))
							var/dz/DZ1221 = O
							if(DZ1221.id != id)
								boom(rand(2,3), O.loc)
						if(!(partslist.Find(O)))
							O.deconstruct()
				else
					if(prob(25))
						boom(rand(2,3), loc)

			if(curdir == "west")
				if(!istype(locate(x - 1, y, z), /turf/simulated/wall))
					loc = locate(x - 1, y, z)
					for(var/obj/O in locate(x - 1, y, z))
						if(istype(O, /dz))
							var/dz/DZ1221 = O
							if(DZ1221.id != id)
								boom(rand(2,3), O.loc)
						if(!(partslist.Find(O)))
							O.deconstruct()
				else
					if(prob(25))
						boom(rand(2,3), loc)

			if(curdir == "east")
				if(!istype(locate(x + 1, y, z), /turf/simulated/wall))
					loc = locate(x + 1, y, z)
					for(var/obj/O in locate(x + 1, y, z))
						if(istype(O, /dz))
							var/dz/DZ1221 = O
							if(DZ1221.id != id)
								boom(rand(2,3), O.loc)
						if(!(partslist.Find(O)))
							O.deconstruct()
				else
					if(prob(25))
						boom(rand(2,3), loc)

	proc/CHECK(var/curdir, var/id)
		if(curdir == "north")
			for(var/dz/DZ in locate(x, y + 1, z))
				if(DZ.id != id)
					boom(rand(2,3), loc)

			if(istype(locate(x, y + 1, z), /turf/simulated/wall))
				if(prob(15))
					boom(rand(2,3), loc)
				return 333

		if(curdir == "south")
			for(var/dz/DZ in locate(x, y - 1, z))
				if(DZ.id != id)
					boom(rand(2,3), loc)

			if(istype(locate(x, y - 1, z), /turf/simulated/wall))
				if(prob(15))
					boom(rand(2,3), loc)
				return 333

		if(curdir == "west")
			for(var/dz/DZ in locate(x - 1, y, z))
				if(DZ.id != id)
					boom(rand(2,3), loc)

			if(istype(locate(x - 1, y, z), /turf/simulated/wall))
				if(prob(15))
					boom(rand(2,3), loc)
				return 333

		if(curdir == "east")
			for(var/dz/DZ in locate(x + 1, y, z))
				if(DZ.id != id)
					boom(rand(2,3), loc)

			if(istype(locate(x + 1, y, z), /turf/simulated/wall))
				if(prob(15))
					boom(rand(2,3), loc)
				return 333

//X = x0 + (x - x0) * cos(a) - (y - y0) * sin(a);
//Y = y0 + (y - y0) * cos(a) + (x - x0) * sin(a);
//(x0, y0) — center