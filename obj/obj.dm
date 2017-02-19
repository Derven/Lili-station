obj
	step_size = 64

/obj/Bumped(atom/movable/MV)
	if(density == 1)
		if(!anchored)
			step(src, MV.dir)

/obj
	proc/initialize()

/obj/proc/hide(h)
	return

/obj/proc/updateUsrDialog()
	var/list/nearby = viewers(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_hand(M)

/obj/proc/updateDialog()
	var/list/nearby = viewers(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_hand(M)

/obj/proc/process()
	processing_objects.Remove(src)
	return 0

/obj
	var/obj/item/parts = null

/obj/proc/deconstruct()
	new parts(src.loc)
	del(src)