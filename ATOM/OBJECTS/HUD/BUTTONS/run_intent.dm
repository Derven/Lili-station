/obj/hud
	run_intent
		icon_state = "walk"
		name = "run_intent"
		screen_loc = "SOUTH-1, WEST+2"

		Click()
			iam.run_intent()
			if(iam.client.run_intent == 2)
				icon_state = "run"
				return
			else
				icon_state = "walk"
				return
