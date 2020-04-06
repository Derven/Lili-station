/obj/hud

	number
		icon_state = "one"
		pixel_y = 1

	stamina
		name = "stamina"
		icon = 'screen1.dmi'
		icon_state = "staminabar"
		screen_loc = "WEST, NORTH-3"

		var/obj/hud/number/SBHUNDREDS //healthbars
		var/obj/hud/number/SBTENS
		var/obj/hud/number/SBUNITS
		var/cur_snum
		var/list/staminanums = list()

		New()
			..()
			clear_overlay()

		proc/clear_overlay()
			overlays.Cut()

		proc/staminapixels()
			clear_overlay()
			var/mob/simulated/living/H = iam
			if(H.stamina < 0 || H.stamina > 100)
				if(H.stamina > 100)
					H.stamina = 100
				else
					return
			if(length(staminanums) == 0)
				SBHUNDREDS = new(staminanums)
				SBTENS = new(staminanums)
				SBUNITS = new(staminanums)

			SBTENS.pixel_x += 7
			SBUNITS.pixel_x += 14

			SBUNITS.pixel_y += 44
			SBTENS.pixel_y += 44
			SBHUNDREDS.pixel_y += 44

			stamina_bar_update(H.stamina)
			cur_snum = H.stamina

			overlays += SBHUNDREDS
			overlays += SBTENS
			overlays += SBUNITS

		proc/stamina_bar_update()
			var/hundreds = round(cur_snum / 100)
			var/tens = round((cur_snum % 100) / 10)
			var/units = (cur_snum % 100) % 10
			SBHUNDREDS.icon_state = select_icon_for_num(hundreds)
			SBTENS.icon_state = select_icon_for_num(tens)
			SBUNITS.icon_state = select_icon_for_num(units)

		proc/select_icon_for_num(var/num)
			switch(num)
				if(1)
					return "one"
				if(2)
					return "two"
				if(3)
					return "three"
				if(4)
					return "four"
				if(5)
					return "five"
				if(6)
					return "six"
				if(7)
					return "seven"
				if(8)
					return "eight"
				if(9)
					return "nine"
				if(0)
					return "zero"

	hungry
		name = "hungry"
		icon = 'screen1.dmi'
		icon_state = "food100"
		screen_loc = "WEST, NORTH-3"

		proc/food_update(var/num)
			switch(num)
				if(70 to 100)
					icon_state = "food100"
				if(50 to 70)
					icon_state = "food70"
				if(30 to 50)
					icon_state = "food50"
				if(10 to 30)
					icon_state = "food30"
				if(0 to 10)
					icon_state = "food10"

	drinking
		name = "thirst"
		icon = 'screen1.dmi'
		icon_state = "food100"
		screen_loc = "WEST, NORTH-4"

		proc/food_update(var/num)
			switch(num)
				if(70 to 100)
					icon_state = "drink100"
				if(50 to 70)
					icon_state = "drink70"
				if(30 to 50)
					icon_state = "drink50"
				if(10 to 30)
					icon_state = "drink30"
				if(0 to 10)
					icon_state = "drink10"

	health
		name = "Health"
		icon = 'screen1.dmi'
		icon_state = "bars"
		screen_loc = "WEST, NORTH-2"
		var/list/healthnums = list()
		var/list/oxynums = list()
		var/list/tempnums = list()
		var/cur_hnum
		var/cur_onum
		var/cur_tnum

		var/obj/hud/number/HBHUNDREDS //healthbars
		var/obj/hud/number/HBTENS
		var/obj/hud/number/HBUNITS
		var/obj/hud/number/OBHUNDREDS //oxybars
		var/obj/hud/number/OBTENS
		var/obj/hud/number/OBUNITS
		var/obj/hud/number/TBHUNDREDS //temperature bars
		var/obj/hud/number/TBTENS
		var/obj/hud/number/TBUNITS

		proc/clear_overlay()
			overlays.Cut()

		proc/healthpixels(var/num)
			var/mob/simulated/living/H = iam
			if(num < 0 || num > 100)
				if(num > 100)
					H.health = 100
				else
					return
			if(length(healthnums) == 0)
				HBHUNDREDS = new(healthnums)
				HBTENS = new(healthnums)
				HBUNITS = new(healthnums)


			HBTENS.pixel_x += 7
			HBUNITS.pixel_x += 13

			health_bar_update(num)
			cur_hnum = num

			overlays += HBHUNDREDS
			overlays += HBTENS
			overlays += HBUNITS

		proc/temppixels(var/num)
			if(num < 0 || num > 800)
				return
			if(length(tempnums) == 0)
				TBHUNDREDS = new(tempnums)
				TBTENS = new(tempnums)
				TBUNITS = new(tempnums)

			TBUNITS.pixel_y += 19
			TBTENS.pixel_y += 19
			TBHUNDREDS.pixel_y += 19

			TBTENS.pixel_x += 7
			TBUNITS.pixel_x += 14

			temp_bar_update(num)
			cur_tnum = num

			overlays += TBHUNDREDS
			overlays += TBTENS
			overlays += TBUNITS

		proc/oxypixels(var/num)
			if(num < 0 || num > 100)
				return
			if(length(oxynums) == 0)
				OBHUNDREDS = new(oxynums)
				OBTENS = new(oxynums)
				OBUNITS = new(oxynums)

			OBUNITS.pixel_y += 38
			OBTENS.pixel_y += 38
			OBHUNDREDS.pixel_y += 38

			OBTENS.pixel_x += 7
			OBUNITS.pixel_x += 14

			oxys_bar_update(num)
			cur_onum = num

			overlays += OBHUNDREDS
			overlays += OBTENS
			overlays += OBUNITS


		New()
			..()
			clear_overlay()
			healthpixels(456)
			temppixels(432)
			oxypixels(78)

		proc/select_icon_for_num(var/num)
			switch(num)
				if(1)
					return "one"
				if(2)
					return "two"
				if(3)
					return "three"
				if(4)
					return "four"
				if(5)
					return "five"
				if(6)
					return "six"
				if(7)
					return "seven"
				if(8)
					return "eight"
				if(9)
					return "nine"
				if(0)
					return "zero"

		proc/health_bar_update(var/num)
			var/hundreds = round(num / 100)
			var/tens = round((num % 100) / 10)
			var/units = (num % 100) % 10
			HBHUNDREDS.icon_state = select_icon_for_num(hundreds)
			HBTENS.icon_state = select_icon_for_num(tens)
			HBUNITS.icon_state = select_icon_for_num(units)

		proc/temp_bar_update(var/num)
			var/hundreds = round(num / 100)
			var/tens = round((num % 100) / 10)
			var/units = (num % 100) % 10
			TBHUNDREDS.icon_state = select_icon_for_num(hundreds)
			TBTENS.icon_state = select_icon_for_num(tens)
			TBUNITS.icon_state = select_icon_for_num(units)

		proc/oxys_bar_update(var/num)
			var/hundreds = round(num / 100)
			var/tens = round((num % 100) / 10)
			var/units = (num % 100) % 10
			OBHUNDREDS.icon_state = select_icon_for_num(hundreds)
			OBTENS.icon_state = select_icon_for_num(tens)
			OBUNITS.icon_state = select_icon_for_num(units)
