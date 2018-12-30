/obj/hud
	sleepbut
		icon_state = "sleep1"
		screen_loc = "SOUTH-1, WEST+3"

		Click()
			var/mob/simulated/living/humanoid/H = iam
			switch(icon_state)
				if("sleep1")
					icon_state = "sleep2"
					H.sleeping()
				else
					icon_state = "sleep1"
					H.awake()
