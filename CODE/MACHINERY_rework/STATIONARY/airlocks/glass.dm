/////WARNING/////
//SHITCODE ALLOWED

/obj/machinery/airlock/glassairlock
	icon = 'glassairlock.dmi'
	opacity = 0

	double_part1
		icon = 'glassairlock1.dmi'

		open()
			for(var/obj/tape/POOLISCLOSED in src.loc)
				return
			if(!close)
				return
			for(var/obj/machinery/airlock/glassairlock/double_part2/P2 in range(1, src))
				if(P2.close)
					P2.open()
			for(var/mob/MB in range(5, src))
				MB.playsoundforme('airlock.ogg')
			flick("open_state",src)
			icon_state = "open"
			close = 0
			density = 0
			if(!istype(src, /obj/machinery/airlock/glassairlock))
				opacity = 0
			if(istype(loc, /turf/simulated))
				var/turf/simulated/floor/T = get_turf(src)
				//SetOpacity(0)
				T.blocks_air = 0
				update_nearby_tiles()
			spawn(150)
				close()

		close()
			for(var/obj/tape/POOLISCLOSED in src.loc)
				return
			if(close)
				return
			for(var/mob/simulated/living/humanoid/M in get_turf(src))
				if(M.density && M != src)
					spawn(60)
						close()
					return
			for(var/mob/MB in range(5, src))
				MB.playsoundforme('airlock.ogg')
			close = 1
			for(var/obj/machinery/airlock/glassairlock/double_part2/P2 in range(1, src))
				if(!P2.close)
					P2.close()
			if(istype(loc, /turf/simulated))
				var/turf/simulated/floor/T = get_turf(src)
				//SetOpacity(1)
				T.check_in_your_pocket()
				T.blocks_air = 1
				update_nearby_tiles()
			density = 1
			if(!istype(src, /obj/machinery/airlock/glassairlock))
				opacity = 1
			flick("close_state",src)
			icon_state = "close"

	double_part2
		icon = 'glassairlock2.dmi'

		open()
			for(var/obj/tape/POOLISCLOSED in src.loc)
				return
			if(!close)
				return
			for(var/mob/MB in range(5, src))
				MB.playsoundforme('airlock.ogg')
			flick("open_state",src)
			icon_state = "open"
			close = 0
			for(var/obj/machinery/airlock/glassairlock/double_part1/P1 in range(1, src))
				if(P1.close)
					P1.open()
			density = 0
			if(!istype(src, /obj/machinery/airlock/glassairlock))
				opacity = 0
			if(istype(loc, /turf/simulated))
				var/turf/simulated/floor/T = get_turf(src)
				//SetOpacity(0)
				T.blocks_air = 0
				update_nearby_tiles()
			spawn(150)
				close()

		close()
			for(var/obj/tape/POOLISCLOSED in src.loc)
				return
			if(close)
				return
			for(var/mob/simulated/living/humanoid/M in get_turf(src))
				if(M.density && M != src)
					spawn(60)
						close()
					return
			for(var/mob/MB in range(5, src))
				MB.playsoundforme('airlock.ogg')
			close = 1
			for(var/obj/machinery/airlock/glassairlock/double_part1/P1 in range(1, src))
				if(!P1.close)
					P1.close()
			if(istype(loc, /turf/simulated))
				var/turf/simulated/floor/T = get_turf(src)
				//SetOpacity(1)
				T.check_in_your_pocket()
				T.blocks_air = 1
				update_nearby_tiles()
			density = 1
			if(!istype(src, /obj/machinery/airlock/glassairlock))
				opacity = 1
			flick("close_state",src)
			icon_state = "close"