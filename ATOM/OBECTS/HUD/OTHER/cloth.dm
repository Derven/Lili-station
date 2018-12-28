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
	backpack
		icon_state = "cloth"
		screen_loc = "SOUTH-1, WEST+4"
		invisibility = 101
		var/image/backoverlay

		Click()
			var/obj/item/I = iam.get_active_hand()
			var/obj/item/weapon/storage/box/backpack/myback = I
			if(myback && istype(myback,/obj/item/weapon/storage/box/backpack))
				if(iam.back == null)
					if(backoverlay)
						backoverlay.layer = initial(backoverlay.layer)
					iam.drop_item(src)
					myback.layer = 21
					iam.back = myback
					backoverlay = image('suit.dmi',icon_state = myback.icon_state)
					backoverlay.layer = 22
					iam.overlays += backoverlay
					update_slot(myback)

/obj/hud
	switcher
		icon_state = "switcher"
		screen_loc = "SOUTH-1, WEST+5"

		Click()
			flick("switcher_flick", src)
			if(cur_cloth_slot == 1) //cloth
				cur_cloth_slot = 0 //id
				iam.CL.invisibility = 101
				iam.BP.invisibility = 101
				if(iam.cloth)
					iam.cloth.invisibility = 101
				if(iam.back)
					iam.back.invisibility = 101
				iam.ID.invisibility = 0
				if(iam.id)
					iam.id.invisibility = 0
				return
			if(cur_cloth_slot == 0) //id
				cur_cloth_slot = -1 //backpack
				iam.ID.invisibility = 101
				iam.CL.invisibility = 101
				iam.BP.invisibility = 0
				if(iam.id)
					iam.id.invisibility = 101
				if(iam.cloth)
					iam.cloth.invisibility = 101
				if(iam.back)
					iam.back.invisibility = 0
				return
			else
				cur_cloth_slot = 1 //cloth
				iam.BP.invisibility = 101
				iam.ID.invisibility = 101
				if(iam.id)
					iam.id.invisibility = 101
				if(iam.back)
					iam.back.invisibility = 101
				iam.CL.invisibility = 0
				if(iam.cloth)
					iam.cloth.invisibility = 0
				return
				 //top feature