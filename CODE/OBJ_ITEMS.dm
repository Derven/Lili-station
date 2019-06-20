// /obj/items vars
//-----------------------
/obj/item/name = "item"
/obj/item/flags = FPRINT | TABLEPASS
/obj/item/pass_flags = PASSTABLE
/obj/item/pressure_resistance = 50

/obj/item/var/icon_old = null//For when weapons get bloodied this saves their old icon.
/obj/item/var/abstract = 0
/obj/item/var/item_state = null
/obj/item/var/damtype = "brute"
/obj/item/var/r_speed = 1.0
/obj/item/var/health = null
/obj/item/var/burn_point = null
/obj/item/var/burning = null
/obj/item/var/hitsound = null
/obj/item/var/w_class = 3.0
/obj/item/var/wielded = 0
/obj/item/var/twohanded = 0 ///Two handed and wielded off by default, nyoro~n -Agouri
/obj/item/var/force_unwielded = 0
/obj/item/var/force_wielded = 0
/obj/item/var/force
//	causeerrorheresoifixthis
/obj/item/var/obj/item/master = null
/obj/item/var/image/I
//-----------------------

// /obj/items procs
//-----------------------
/obj/item/attack_hand(mob/simulated/living/humanoid/user as mob)
	if(user.death == 0 && !istype(src, /mob/ghost))
		Move(user)
		src.layer = 20

		if (user.hand)
			if(src == user.l_hand || src == user.r_hand || src == user.cloth || src == user.back || src == user.id || src == user.PDA)
				user.u_equip(src)
				if(istype(src, /obj/item/clothing))
					var/obj/item/clothing/clthg = src
					clthg.wear_clothing(user)

			user.l_hand = src
			user.l_arm.HUD.update_slot(src)
		else
			if(src == user.l_hand || src == user.r_hand || src == user.cloth  || src == user.back  || src == user.id || src == user.PDA)
				user.u_equip(src)
				if(istype(src, /obj/item/clothing))
					var/obj/item/clothing/clthg = src
					clthg.wear_clothing(user)
			user.r_hand = src
			user.r_arm.HUD.update_slot(src)

		src.pickup(user)

/obj/item/proc/afterattack(var/atom/movable/M, var/mob/simulated/user)
	if(istype(M, /mob/simulated/living))
		M:attacked_by(src, user, parse_zone(user.ZN_SEL.selecting))
	return

/obj/item/proc/pickup(mob/user)
	if(src == usr:r_hand || src == usr:l_hand)
		add_inhand(usr)
	pixel_z = 0
	return

/obj/item/proc/dropped(mob/user as mob)
	..()

/obj/item/proc/wear_clothing(var/mob/simulated/living/humanoid/M)
	if(src == M.cloth)
		if(M.gender == "male")
			I = image(icon = src.icon, icon_state = "[src.icon_state]_onmob")
			M.overlays += I
			return
		else
			I = image(icon = src.icon, icon_state = "[src.icon_state]_onfem")
			M.overlays += I
	else
		M.overlays -= I
		return