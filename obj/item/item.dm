/obj/item/proc/afterattack(var/atom/movable/M, var/mob/user)
	if(istype(M, /mob))
		M:attacked_by(src, user, parse_zone(user.ZN_SEL.selecting))
	return

/obj/item/proc/pickup(mob/user)
	pixel_z = 0
	return

/obj/item/attack_hand(mob/user as mob)
	if(user.death == 0 && !istype(src, /mob/ghost))
		Move(user)
		src.layer = 20

		if (user.hand)
			if(src == user.l_hand || src == user.r_hand || src == user.cloth)
				user.u_equip(src)
				if(istype(src, /obj/item/clothing))
					var/obj/item/clothing/clthg = src
					clthg.wear_clothing(user)

			user.l_hand = src
			user.LH.update_slot(src)
		else
			if(src == user.l_hand || src == user.r_hand || src == user.cloth)
				user.u_equip(src)
				if(istype(src, /obj/item/clothing))
					var/obj/item/clothing/clthg = src
					clthg.wear_clothing(user)
			user.r_hand = src
			user.RH.update_slot(src)

		src.pickup(user)

/obj/item/proc/dropped(mob/user as mob)
	..()

/obj/item
	name = "item"
	var/icon_old = null//For when weapons get bloodied this saves their old icon.
	var/abstract = 0
	var/item_state = null
	var/damtype = "brute"
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	var/hitsound = null
	var/w_class = 3.0
	var/wielded = 0
	var/twohanded = 0 ///Two handed and wielded off by default, nyoro~n -Agouri
	var/force_unwielded = 0
	var/force_wielded = 0
	flags = FPRINT | TABLEPASS
	pass_flags = PASSTABLE
	pressure_resistance = 50
//	causeerrorheresoifixthis
	var/obj/item/master = null
	var/image/I

	proc/wear_clothing(var/mob/M)
		if(src == M.cloth)
			if(M.icon_state == "mob")
				I = image(icon = src.icon, icon_state = "[src.icon_state]_onmob")
				M.overlays += I
				return
			else
				I = image(icon = src.icon, icon_state = "[src.icon_state]_onfem")
				M.overlays += I
		else
			M.overlays -= I
			return

/obj/item/clothing/suit
	icon = 'suit.dmi'
	var/space_suit = 0

/obj/item/clothing/suit/soviet
	icon_state = "soviet_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/assistant
	icon_state = "assistant_suit"

/obj/item/clothing/suit/NTspace
	icon_state = "NT_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/syndispace
	icon_state = "syndi_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/bartender
	icon_state = "bartender_suit"

/obj/item/clothing/suit/security_suit
	icon_state = "security_suit"

/obj/item/clothing/suit/eng_suit
	icon_state = "eng_suit"

/obj/item/clothing/suit/med
	icon_state = "med_suit"

/obj/item/clothing/suit/hydro_suit
	icon_state = "hydro_suit"


/obj/item
	var
		force