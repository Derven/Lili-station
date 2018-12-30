/obj/machinery/ind_smelter
	icon = 'stationobjs.dmi'
	icon_state = "ind_smelt"

	process()
		for(var/atom/A in src.loc)
			if((istype(A, /obj) || istype(A, /mob)) && !istype(A, /mob/ghost))
				if(A != src)
					var/charge = rand(1050, 2400)
					for(var/obj/machinery/simple_apc/SA in range(4, src))
						SA.my_smes.charge += charge
					if(istype(A, /mob))
						var/mob/simulated/M = A
						M.death()
					for(var/mob/M in range(5, src))
						M << 'ding.ogg'
					del(A)