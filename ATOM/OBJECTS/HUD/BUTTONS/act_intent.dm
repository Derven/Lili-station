/obj/hud
	act_intent
		icon_state = "help"
		screen_loc = "SOUTH-1, WEST+2"

		Click()
			iam.switch_intent()
			if(iam.intent == 0)
				icon_state = "harm"
				return
			else
				icon_state = "help"
				return

	ex_act()
		return