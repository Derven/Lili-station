/obj/hud
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