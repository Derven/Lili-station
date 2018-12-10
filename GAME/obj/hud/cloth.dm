/obj/hud
	var/cur_cloth_slot = 1

	cloth
		icon_state = "cloth"
		screen_loc = "SOUTH-1, WEST+4"

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

/obj/hud
	id
		icon_state = "id"
		screen_loc = "SOUTH-1, WEST+4"
		invisibility = 101

		Click()
			var/obj/item/I = iam.get_active_hand()
			var/obj/item/clothing/id/myid = I
			if(myid && istype(myid,/obj/item/clothing/id))
				if(myid && iam.id == null)
					iam.drop_item(src)
					myid.layer = 21
					iam.id = myid
					update_slot(myid)

/obj/hud
	switcher
		icon_state = "switcher"
		screen_loc = "SOUTH-1, WEST+5"

		Click()
			flick("switcher_flick", src)
			if(cur_cloth_slot == 1) //cloth
				cur_cloth_slot = 0 //id
				iam.CL.invisibility = 101
				if(iam.cloth)
					iam.cloth.invisibility = 101
				iam.ID.invisibility = 0
				if(iam.id)
					iam.id.invisibility = 0
			else
				cur_cloth_slot = 1 //cloth
				iam.ID.invisibility = 101
				if(iam.id)
					iam.id.invisibility = 101
				iam.CL.invisibility = 0
				if(iam.cloth)
					iam.cloth.invisibility = 0
				 //top feature