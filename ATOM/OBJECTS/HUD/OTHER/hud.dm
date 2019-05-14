obj/hud
	layer = 18
	icon = 'screen1.dmi'
	var/mob/iam = null
	mouse_over_pointer = MOUSE_HAND_POINTER

	proc/update_slot(var/obj/item/I)
		if(I)
			I.screen_loc = screen_loc
			if(istype(iam, /mob/simulated/living))
				iam.client.screen.Add(I)
			else
				var/datum/organ/external/EX = iam
				EX.CLIENT.screen.Add(I)

	New(var/mob/M)
		..()
		iam = M