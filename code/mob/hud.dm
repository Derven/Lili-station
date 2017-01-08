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

	l_hand
		icon_state = "l_hand"
		screen_loc = "SOUTH, 7"

		Click()
			iam.swap_hand()

	r_hand
		icon_state = "r_hand"
		screen_loc = "SOUTH, 8"

		Click()
			iam.swap_hand()

	drop
		icon_state = "drop"
		screen_loc = "SOUTH, 9"

		Click()
			iam.drop_item_v()

	pulling
		icon_state = "pull_1"
		screen_loc = "SOUTH, 6"

		Click()
			if(iam.pulling)
				iam.pulling = null
				iam.update_pulling()

/mob
	var
		obj/hud/l_hand/LH
		obj/hud/r_hand/RH
		obj/hud/drop/DP
		obj/hud/pulling/PULL

	proc
		create_hud(var/client/C)
			LH = new(src)
			RH = new(src)
			DP = new(src)
			PULL = new(src)

			C.screen.Add(LH)
			C.screen.Add(RH)
			C.screen.Add(DP)
			C.screen.Add(PULL)
