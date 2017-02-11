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
		screen_loc = "SOUTH-1, WEST"

		Click()
			iam.swap_hand()

	act_intent
		icon_state = "help"
		screen_loc = "SOUTH-1, WEST+5"

		Click()
			iam.switch_intent()
			if(iam.intent == 0)
				icon_state = "harm"
				return
			else
				icon_state = "help"
				return

	hide_walls
		icon_state = "hide_wall"
		screen_loc = "SOUTH-1, WEST+6"

		Click()
			for(var/turf/simulated/wall/W in view(iam))
				W.hide_me()
				spawn(25)
					W.clear_images()

	r_hand
		icon_state = "r_hand"
		screen_loc = "SOUTH-1, WEST+1"

		Click()
			iam.swap_hand()

	drop
		icon_state = "drop"
		screen_loc = "SOUTH-1, WEST+2"

		Click()
			iam.drop_item_v()
/*
	rose_of_winds
		icon_state = "rose_of_winds"
		screen_loc = "SOUTH-1, WEST+5"

		Click()
			if(iam.client.dir == NORTH)
				icon_state = "rose_of_winds_e"
				iam.client.dir = EAST
				return

			if(iam.client.dir == EAST)
				icon_state = "rose_of_winds_s"
				iam.client.dir = SOUTH
				return

			if(iam.client.dir == SOUTH)
				icon_state = "rose_of_winds_w"
				iam.client.dir = WEST
				return

			if(iam.client.dir == WEST)
				icon_state = "rose_of_winds_n"
				iam.client.dir = NORTH
				return
*/
	cloth
		icon_state = "cloth"
		screen_loc = "SOUTH-1, WEST+3"

		Click()
			var/obj/item/I = iam.get_active_hand()
			if(I && istype(I,/obj/item/clothing/suit))
				var/obj/item/clothing/suit/mysuit = I
				if(I && iam.cloth == null)
					iam.drop_item(src)
					I.layer = 21
					iam.cloth = I
					update_slot(I)
					mysuit.wear_clothing(iam)

	pulling
		icon_state = "pull_1"
		screen_loc = "SOUTH-1, WEST+4"

		Click()
			if(iam.pulling)
				iam.stop_pulling()

	zone_sel
		name = "Damage Zone"
		icon = 'zone_sel.dmi'
		icon_state = "blank"
		var/selecting = "chest"
		var/image/myzone
		screen_loc = "WEST,NORTH"

		MouseDown(location, control,params)
			// Changes because of 4.0
			var/list/PL = params2list(params)
			var/icon_x = text2num(PL["icon-x"])
			var/icon_y = text2num(PL["icon-y"])

			if (icon_y < 2)
				return
			else if (icon_y < 10)
				if ((icon_x > 9 && icon_x < 26))
					if (icon_x < 16)
						selecting = "r_foot"
					else
						selecting = "l_foot"

			else if (icon_y < 25)
				if ((icon_x > 7 && icon_x < 26))
					if (icon_x < 16)
						selecting = "r_leg"
					else
						selecting = "l_leg"

			else if (icon_y < 29)
				if ((icon_x > 11 && icon_x < 23))
					if (icon_x < 14)
						selecting = "r_leg"
					else if (icon_x < 19)
						selecting = "groin"
					else
						selecting = "l_leg"
				else
					return
			else if (icon_y < 34)
				if ((icon_x > 4 && icon_x < 30))
					if (icon_x < 12)
						selecting = "r_hand"
					else if (icon_x < 22)
						selecting = "groin"
					else
						selecting = "l_hand"
				else
					return

			else if (icon_y < 48)
				if ((icon_x > 5 && icon_x < 30))
					if (icon_x < 10)
						selecting = "r_arm"
					else if (icon_x < 25)
						selecting = "chest"
					else
						selecting = "l_arm"
				else
					return

			else if (icon_y < 56)
				if ((icon_x > 12 && icon_x < 21))
					selecting = "mouth"
				else
					return

			else if (icon_y < 59)
				if ((icon_x > 12 && icon_x < 21))
					selecting = "head"
				else
					return

			else
				selecting = "eyes"

			myzone = image("icon" = 'zone_sel.dmi', "icon_state" = text("[]", selecting))
			upd_znsel()

			overlays = null
			overlays += myzone

			return

		proc/upd_znsel()
			if(selecting != "eyes" && selecting != "mouth" && selecting != "r_hand" && selecting != "l_hand" && selecting != "r_foot" && selecting != "l_foot")
				myzone.color = iam.upd_status(iam.get_organ(selecting))

/mob
	var
		obj/hud/l_hand/LH
		obj/hud/r_hand/RH
		obj/hud/drop/DP
		obj/hud/pulling/PULL
		obj/hud/zone_sel/ZN_SEL
		obj/hud/cloth/CL
		//obj/hud/rose_of_winds/ROW
		obj/hud/hide_walls/HW
		obj/hud/act_intent/AC

	proc
		create_hud(var/client/C)
			LH = new(src)
			RH = new(src)
			DP = new(src)
			PULL = new(src)
			ZN_SEL = new(src)
			CL = new(src)
			AC = new(src)
			//ROW = new(src)
			HW = new(src)

			C.screen.Add(LH)
			C.screen.Add(RH)
			C.screen.Add(DP)
			C.screen.Add(PULL)
			C.screen.Add(ZN_SEL)
			C.screen.Add(CL)
			//C.screen.Add(ROW)
			C.screen.Add(HW)
			C.screen.Add(AC)
