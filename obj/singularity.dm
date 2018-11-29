/obj/singularity
	icon = 'singularity.dmi'
	icon_state = "singularity"
	density = 0
	var
		plevel = 1
		sing_max_gp = 5
		innerpower = 0

	process()
		var/buffer_x = x + rand(-1, 1)
		var/buffer_y = y + rand(-1, 1)
		if(check_xy(buffer_x, buffer_y) > 0 && (buffer_x == x || buffer_y == y)) //no diagonal
			x = buffer_x
			y = buffer_y
		if(plevel < 3)
			for(var/obj/energyfield/EF in range(4 + plevel, src))
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
						var/mob/MOB = M
						MOB.death()
					if(istype(M, /mob/ghost))
						return
					del(M)
					innerpower += rand(30, 70)
		for(var/turf/T in range(rand(1,2)  + plevel, src))
			del(T)

	proc/check_xy(var/x, var/y)
		for(var/obj/energyfield/EF in locate(x,y,1))
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