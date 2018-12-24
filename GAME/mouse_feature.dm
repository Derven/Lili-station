client
	var/mdown = 0
	var/mloc

client/MouseDown(var/atom/O, var/turf/T)
	mdown = 1
	mloc = T
	if(!istype(mob, /mob/ghost))
		var/obj/item/I = mob.get_active_hand()
		if(istype(I, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/G = I
			if(G.automatic == 1)
				while(mdown == 1)
					sleep(1)
					I.afterattack(mloc)
			else
				I.afterattack(mloc)
	..()


client/MouseMove(var/turf/T)
	mloc = T
	..()

client/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	var/atom/A = src_location
	if(istype(A, /turf))
		mloc = A
	else if(istype(A, /area))
		return
	else
		if(A && A.loc)
			mloc = A.loc
	..()

client/MouseUp()
	mdown = 0