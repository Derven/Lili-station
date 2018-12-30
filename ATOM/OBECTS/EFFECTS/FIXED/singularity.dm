//shit but ok
/obj/item/projectile/beam/particles

/obj/singgen
	icon = 'stationobjs.dmi'
	icon_state = "singen"

	bullet_act(var/obj/item/projectile/Proj)
		if(istype(Proj, /obj/item/projectile/beam/particles))
			new /obj/singularity(src.loc)
			del(Proj)
			del(src)

/obj/singularity
	icon = 'singularity.dmi'
	icon_state = "singularity"
	density = 0
	var
		plevel = 1
		sing_max_gp = 5
		innerpower = 0

	New()
		START_PROCESSING(SSobj, src)

	proc/generate_energy()
		for(var/obj/machinery/collector/C in world)
			C.power_generate()

	process()
		var/buffer_x = x + rand(-1, 1)
		var/buffer_y = y + rand(-1, 1)
		if(check_xy(buffer_x, buffer_y) > 0 && (buffer_x == x || buffer_y == y)) //no diagonal
			x = buffer_x
			y = buffer_y
		generate_energy()
		if(plevel < 3)
			for(var/obj/machinery/containment_field/EF in range(4 + plevel, src))
				return
		if(innerpower > geom_prg(plevel + 1, plevel + 1, 1, sing_max_gp) && plevel < sing_max_gp)
			plevel += 1
			//world << "level UP [plevel]"
		for(var/atom/movable/M in range(rand(2,4) + plevel, src))
			M.anchored = 0
			walk_to(M, src, 1, 1, 1)
			if(M in range(rand(1,2),src))
				if(M != src)
					if(istype(M, /mob) && !istype(M, /mob/ghost))
						var/mob/simulated/MOB = M
						MOB.death()
					if(istype(M, /mob/ghost))
						return
					del(M)
					innerpower += rand(30, 70)
		for(var/turf/T in range(rand(1,2)  + plevel, src))
			del(T)

	proc/check_xy(var/x, var/y)
		for(var/obj/machinery/containment_field/EF in locate(x,y,1))
			if(plevel < 3)
				return 0
			else
				return 1
		return 1

/obj/energyfield
	icon_state = "e_line"
	icon = 'stationobjs.dmi'

	//process()
	//	sleep(rand(2,4))
	//	del(src)

proc/geom_prg(var/i, var/g, var/counter, var/mxcnt)
	while(counter < mxcnt)
		i = i * g
		counter += 1
	return i

/obj/machinery/consol/singularity
	proc/check_all_connect()
		for(var/obj/machinery/pa/segment1/s1 in world)
			if(s1.connect() == 0)
				return 0
		for(var/obj/machinery/pa/segment2/s2 in world)
			if(s2.connect() == 0)
				return 0
		for(var/obj/machinery/pa/segment3/s3 in world)
			if(s3.connect() == 0)
				return 0
		for(var/obj/machinery/pa/segment4/s4 in world)
			if(s4.connect() == 0)
				return 0
		return 1

	proc/pewpew()
		if(check_all_connect() == 1)
			for(var/obj/machinery/pa/segment4/s4 in world)
				var/obj/item/projectile/beam/particles/A = new /obj/item/projectile/beam/particles(s4.loc)
				A.dir = 4
				A.process()

	attack_hand()
		pewpew()

/obj/machinery/pa
	icon = 'stationobjs.dmi'
	density = 1
	anchored = 1

	proc/connect()
	segment1
		icon_state = "1"
		connect()
			for(var/obj/machinery/pa/segment2/S in locate(x + 1, y, z))
				return 1
			for(var/obj/machinery/pa/segment2/S in locate(x - 1, y, z))
				return 1
			return 0
	segment2
		icon_state = "2"
		connect()
			for(var/obj/machinery/pa/segment3/S in locate(x + 1, y, z))
				return 1
			for(var/obj/machinery/pa/segment3/S in locate(x - 1, y, z))
				return 1
			return 0
	segment3
		icon_state = "3"
		connect()
			for(var/obj/machinery/pa/segment4/S in locate(x + 1, y, z))
				return 1
			for(var/obj/machinery/pa/segment4/S in locate(x - 1, y, z))
				return 1
			return 0
	segment4
		icon_state = "4"
		connect()
			var/ret = 0
			for(var/obj/machinery/pa/segment3/S in locate(x + 1, y, z))
				ret = 1
			for(var/obj/machinery/pa/segment3/S in locate(x - 1, y, z))
				ret = 1
			for(var/obj/machinery/pa/segment5/S in locate(x, y + 1, z))
				ret += 1
			for(var/obj/machinery/pa/segment5/S in locate(x, y - 1, z))
				ret += 1
			for(var/obj/machinery/pa/segment6/S in locate(x, y + 1, z))
				ret += 1
			for(var/obj/machinery/pa/segment6/S in locate(x, y - 1, z))
				ret += 1
			if(ret == 3)
				return 1
			return 0
	segment5
		icon_state = "4"
	segment6
		icon_state = "4"