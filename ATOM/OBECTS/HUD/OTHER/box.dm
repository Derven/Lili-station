/obj/hud
	box
		icon_state = "box"
		screen_loc = "SOUTH+5, WEST+5"
		var/obj/item/myitem

	box_close
		icon_state = "close"

		Click()
			for(var/obj/hud/box/B in iam.boxes)
				iam.client.screen.Remove(B)
				iam.boxes -= B
				iam.client.screen.Remove(B.myitem)
				B.myitem = null
			iam.client.screen.Remove(src)