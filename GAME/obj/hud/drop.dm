/obj/hud
	drop
		icon_state = "drop"
		screen_loc = "SOUTH-1, WEST+2"

		Click()
			iam.drop_item_v()
			iam.doing_this = 0
