client
	var/mdown = 0
	var/mloc

client/MouseDown(var/atom/O, var/turf/T)
	mdown = 1
	..()
	if(!istype(mob, /mob/ghost))
		var/obj/item/I = mob.get_active_hand()
		if(istype(I, /obj/item/weapon/gun))
			I.afterattack(mloc)
			MouseMove()
		return

client/MouseMove(var/turf/T)
	mloc = T

client/MouseUp()
	mdown = 0