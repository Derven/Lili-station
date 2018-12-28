/obj/hud
	sleepbut
		icon_state = "sleep1"
		screen_loc = "SOUTH-1, WEST+3"

		Click()
			switch(icon_state)
				if("sleep1")
					icon_state = "sleep2"
					iam.sleeping()
				else
					icon_state = "sleep1"
					iam.awake()
