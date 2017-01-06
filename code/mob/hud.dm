obj/hud
	layer = 18
	var/mob/iam = null

	proc/update_slot(var/obj/item/I)
		I.screen_loc = screen_loc
		iam.client.screen.Add(I)

	New(var/mob/M)
		..()
		iam = M

obj/hud/l_hand
	icon = 'screen1.dmi'
	icon_state = "l_hand"
	screen_loc = "SOUTH, 7"

	Click()
		iam.swap_hand()

obj/hud/r_hand
	icon = 'screen1.dmi'
	icon_state = "r_hand"
	screen_loc = "SOUTH, 8"

	Click()
		iam.swap_hand()

obj/hud/drop
	icon = 'screen1.dmi'
	icon_state = "drop"
	screen_loc = "SOUTH, 9"

	Click()
		iam.drop_item_v()

/mob
	var
		obj/hud/l_hand/LH
		obj/hud/r_hand/RH
		obj/hud/drop/DP

	proc
		create_hud(var/client/C)
			LH = new(src)
			RH = new(src)
			DP = new(src)

			C.screen.Add(LH)
			C.screen.Add(RH)
			C.screen.Add(DP)