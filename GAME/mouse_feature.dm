client
	var/mdown = 0
	var/mloc

client/MouseDown(var/atom/O, var/turf/T)
	mdown = 1
	mloc = T
	if(!istype(mob, /mob/ghost))
		var/obj/item/I = mob.get_active_hand()
		if(istype(I, /obj/item/weapon/gun))
			while(mdown == 1)
				sleep(1)
				I.afterattack(mloc)
	..()


client/MouseMove(var/turf/T)
	..()

client/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	var/atom/A = src_location
	if(istype(A, /turf))
		mloc = A
	else if(istype(A, /area))
		return
	else
		mloc = A.loc
	..()

client/MouseUp()
	mdown = 0