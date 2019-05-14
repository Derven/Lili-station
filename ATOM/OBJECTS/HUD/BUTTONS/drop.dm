/obj/hud
	drop
		icon_state = "drop"
		screen_loc = "SOUTH-1, WEST+2"

		Click()
			var/mob/simulated/living/humanoid/H = iam
			H.drop_item_v()
			H.doing_this = 0
