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

	zone_sel
		name = "Damage Zone"
		icon = 'zone_sel.dmi'
		icon_state = "blank"
		var/selecting = "chest"
		screen_loc = "EAST+1,NORTH"

		MouseDown(location, control,params)
			// Changes because of 4.0
			var/list/PL = params2list(params)
			var/icon_x = text2num(PL["icon-x"])
			var/icon_y = text2num(PL["icon-y"])

			if (icon_y < 2)
				return
			else if (icon_y < 5)
				if ((icon_x > 9 && icon_x < 23))
					if (icon_x < 16)
						selecting = "r_foot"
					else
						selecting = "l_foot"
			else if (icon_y < 11)
				if ((icon_x > 11 && icon_x < 21))
					if (icon_x < 16)
						selecting = "r_leg"
					else
						selecting = "l_leg"
			else if (icon_y < 12)
				if ((icon_x > 11 && icon_x < 21))
					if (icon_x < 14)
						selecting = "r_leg"
					else if (icon_x < 19)
						selecting = "groin"
					else
						selecting = "l_leg"
				else
					return
			else if (icon_y < 13)
				if ((icon_x > 7 && icon_x < 25))
					if (icon_x < 12)
						selecting = "r_hand"
					else if (icon_x < 13)
						selecting = "r_leg"
					else if (icon_x < 20)
						selecting = "groin"
					else if (icon_x < 21)
						selecting = "l_leg"
					else
						selecting = "l_hand"
				else
					return
			else if (icon_y < 14)
				if ((icon_x > 7 && icon_x < 25))
					if (icon_x < 12)
						selecting = "r_hand"
					else if (icon_x < 21)
						selecting = "groin"
					else
						selecting = "l_hand"
				else
					return
			else if (icon_y < 16)
				if ((icon_x > 7 && icon_x < 25))
					if (icon_x < 13)
						selecting = "r_hand"
					else if (icon_x < 20)
						selecting = "chest"
					else
						selecting = "l_hand"
				else
					return
			else if (icon_y < 23)
				if ((icon_x > 7 && icon_x < 25))
					if (icon_x < 12)
						selecting = "r_arm"
					else if (icon_x < 21)
						selecting = "chest"
					else
						selecting = "l_arm"
				else
					return
			else if (icon_y < 24)
				if ((icon_x > 11 && icon_x < 21))
					selecting = "chest"
				else
					return
			else if (icon_y < 25)
				if ((icon_x > 11 && icon_x < 21))
					if (icon_x < 16)
						selecting = "head"
					else if (icon_x < 17)
						selecting = "mouth"
					else
						selecting = "head"
				else
					return
			else if (icon_y < 26)
				if ((icon_x > 11 && icon_x < 21))
					if (icon_x < 15)
						selecting = "head"
					else if (icon_x < 18)
						selecting = "mouth"
					else
						selecting = "head"
				else
					return
			else if (icon_y < 27)
				if ((icon_x > 11 && icon_x < 21))
					if (icon_x < 15)
						selecting = "head"
					else if (icon_x < 16)
						selecting = "eyes"
					else if (icon_x < 17)
						selecting = "mouth"
					else if (icon_x < 18)
						selecting = "eyes"
					else
						selecting = "head"
				else
					return
			else if (icon_y < 28)
				if ((icon_x > 11 && icon_x < 21))
					if (icon_x < 14)
						selecting = "head"
					else if (icon_x < 19)
						selecting = "eyes"
					else
						selecting = "head"
				else
					return
			else if (icon_y < 29)
				if ((icon_x > 11 && icon_x < 21))
					if (icon_x < 15)
						selecting = "head"
					else if (icon_x < 16)
						selecting = "eyes"
					else if (icon_x < 17)
						selecting = "head"
					else if (icon_x < 18)
						selecting = "eyes"
					else
						selecting = "head"
				else
					return
			else if (icon_y < 31)
				if ((icon_x > 11 && icon_x < 21))
					selecting = "head"
				else
					return
			else
				return

			overlays = null
			overlays += image("icon" = 'zone_sel.dmi', "icon_state" = text("[]", selecting))

			return

/mob
	var
		obj/hud/l_hand/LH
		obj/hud/r_hand/RH
		obj/hud/drop/DP
		obj/hud/pulling/PULL
		obj/hud/zone_sel/ZN_SEL

	proc
		create_hud(var/client/C)
			LH = new(src)
			RH = new(src)
			DP = new(src)
			PULL = new(src)
			ZN_SEL = new(src)

			C.screen.Add(LH)
			C.screen.Add(RH)
			C.screen.Add(DP)
			C.screen.Add(PULL)
			C.screen.Add(ZN_SEL)
