obj/hud
	layer = 18
	icon = 'screen1.dmi'
	var/mob/iam = null

	proc/update_slot(var/obj/item/I)
		I.screen_loc = screen_loc
		iam.client.screen.Add(I)

	New(var/mob/M)
		..()
		iam = M