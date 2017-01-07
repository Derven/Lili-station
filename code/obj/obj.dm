/obj/item
	var
		force

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

/obj/item/weapon/wrench
	icon = 'tools.dmi'
	icon_state = "wrench"

/obj/item/pipe_meter

/obj/effect/overlay

/obj/item/clothing/mask

/obj/item/device/detective_scanner
	icon = 'device.dmi'

/obj/item/weapon

/obj/item/weapon/cleaner

/obj/item/weapon/plastique

/obj/item/weapon/chemsprayer

/obj/item/weapon/pepperspray

/obj/item/weapon/plantbgone

/obj/item/pipe

/obj/item/device/analyzer

/obj/item/weapon/wirecutters
	icon = 'tools.dmi'
	icon_state = "cutters"

/obj/item/weapon/weldingtool
	icon = 'tools.dmi'
	icon_state = "welder"
	var/volume = 60

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(volume)
		reagents = R
		R.my_atom = src
		R.add_reagent("diesel", 40)

	proc/use()
		if(reagents.has_reagent("diesel", 10))
			reagents.remove_reagent("diesel", 10, 0)
			return 1
		else
			return 0

/obj/effect/list_container
	name = "list container"

/obj/item/weapon/gun

/obj/structure/stool/bed

/obj/item/weapon/tank

/obj/effect/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list(  )

/obj/proc/process()
	processing_objects.Remove(src)
	return 0

/obj/item/weapon/grab
	name = "grab"
	//icon = 'screen1.dmi'
	icon_state = "grabbed"
	var/obj/screen/grab/hud1 = null
	var/mob/affecting = null
	var/mob/assailant = null
	var/state = 1.0
	var/killing = 0.0
	var/allow_upgrade = 1.0
	var/last_suffocate = 1.0
	layer = 21

/obj/structure/cable/proc/updateicon()
	if(invisibility)
		icon_state = "[d1]-[d2]-f"
	else
		icon_state = "[d1]-[d2]"



/obj/structure/cable
	level = 1
	anchored =1
	var/netnum = 0
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer. Comes in clown color_hyalors now."
	icon = 'power_cond_red.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	layer = 2.5
	var/color_hyalor="red"