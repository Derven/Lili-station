/mob
	icon = 'mob.dmi'
	icon_state = "mob"

/mob/proc/u_equip(obj/item/W as obj)
	if (W == r_hand)
		r_hand = null
	else if (W == l_hand)
		l_hand = null