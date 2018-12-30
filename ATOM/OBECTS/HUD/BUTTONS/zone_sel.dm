/obj/hud
	zone_sel
		name = "Damage Zone"
		icon = 'zone_sel.dmi'
		icon_state = "attack_zone"
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
			var/mob/simulated/living/H = iam
			if(selecting != "eyes" && selecting != "mouth" && selecting != "r_hand" && selecting != "l_hand" && selecting != "r_foot" && selecting != "l_foot")
				myzone.color = H.upd_status(H.get_organ(selecting))