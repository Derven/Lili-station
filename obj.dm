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
	if(parts)
		new parts(src.loc)
	del(src)

/obj
	//var/datum/module/mod		//not used
	var/m_amt = 0	// metal
	var/g_amt = 0	// glass
	var/w_amt = 0	// waster amounts
	var/origin_tech = null	//Used by R&D to determine what research bonuses it grants.
	var/reliability = 100	//Used by SOME devices to determine how reliable they are.
	var/crit_fail = 0
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	var/datum/marked_datum
	animate_movement = 2
	var/throw_hyuowforce = 1