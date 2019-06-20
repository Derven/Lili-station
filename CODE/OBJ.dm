// /obj vars
//---------------------
/obj/step_size = 64
/obj/animate_movement = 2
/obj/var/price = 1
/obj/var/m_amt = 0	// metal
/obj/var/g_amt = 0	// glass
/obj/var/w_amt = 0	// waster amounts
/obj/var/origin_tech = null	//Used by R&D to determine what research bonuses it grants.
/obj/var/reliability = 100	//Used by SOME devices to determine how reliable they are.
/obj/var/crit_fail = 0
/obj/var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
/obj/var/datum/marked_datum
/obj/var/throw_hyuowforce = 1
/obj/var/obj/item/parts = null

// /obj procs
//---------------------
/obj/Bumped(atom/movable/MV)
	if(density == 1 && istype(MV, /mob) && !istype(src, /obj/structure/closet))
		if(!anchored)
			step(src, MV.dir)

/obj/proc/initialize()

/obj/proc/hide(h)
	return

//WARNING!!!
/obj/proc/updateUsrDialog(var/mob/M) //please fix
	if ((M.client && M.machine == src)) //please fix
		src.attack_hand(usr) //please fix

/obj/proc/updateDialog() //please fix
	var/list/nearby = viewers(1, src) //please fix
	for(var/mob/M in nearby) //please fix
		if ((M.client && M.machine == src)) //please fix
			src.attack_hand(M) //please fix
//WARNING!!!

/obj/proc/deconstruct()
	if(parts)
		new parts(src.loc)
	del(src)