/obj/hud
	var/cur_cloth_slot = 1

	show
		icon_state = "show"
		screen_loc = "WEST, SOUTH"
		invisibility = 0

		Click()
			var/mob/simulated/living/humanoid/H = iam
			H.ID.invisibility = 0
			H.CL.invisibility = 0
			H.BP.invisibility = 0
			H.PPDDAA.invisibility = 0
			H.SHOW.invisibility = 101
			H.HIDE.invisibility = 0
			if(H.id)
				H.id.invisibility = 0
			if(H.cloth)
				H.cloth.invisibility = 0
			if(H.back)
				H.back.invisibility = 0
			if(H.PDA)
				H.PDA.invisibility = 0

	hide
		icon_state = "hide"
		screen_loc = "WEST+2, SOUTH"
		invisibility = 101

		Click()
			var/mob/simulated/living/humanoid/H = iam
			H.ID.invisibility = 101
			H.CL.invisibility = 101
			H.BP.invisibility = 101
			H.PPDDAA.invisibility = 101
			H.SHOW.invisibility = 0
			H.HIDE.invisibility = 101
			if(H.id)
				H.id.invisibility = 101
			if(H.cloth)
				H.cloth.invisibility = 101
			if(H.back)
				H.back.invisibility = 101
			if(H.PDA)
				H.PDA.invisibility = 101
	cloth
		icon_state = "cloth"
		screen_loc = "WEST, SOUTH"
		invisibility = 101

		Click()
			var/mob/simulated/living/humanoid/H = iam
			var/obj/item/I = H.get_active_hand()
			if(I && istype(I,/obj/item/clothing/suit))
				var/obj/item/clothing/suit/mysuit = I
				if(I && H.cloth == null)
					H.drop_item(src)
					I.layer = 22
					H.cloth = I
					update_slot(I)
					mysuit.wear_clothing(iam)

/obj/hud
	id
		icon_state = "id"
		screen_loc = "WEST+1, SOUTH+1"
		invisibility = 101

		Click()
			var/mob/simulated/living/humanoid/H = iam
			var/obj/item/I = H.get_active_hand()
			var/obj/item/clothing/id/myid = I
			if(myid && istype(myid,/obj/item/clothing/id))
				if(myid && H.id == null)
					H.drop_item(src)
					myid.layer = 22
					H.id = myid
					update_slot(myid)

/obj/hud
	PDA
		icon_state = "pda"
		screen_loc = "WEST, SOUTH+1"
		invisibility = 101

		Click()
			var/mob/simulated/living/humanoid/H = iam
			var/obj/item/I = H.get_active_hand()
			var/obj/item/clothing/PDA/MYPDA = I
			if(MYPDA && istype(MYPDA,/obj/item/clothing/PDA))
				if(MYPDA && H.PDA == null)
					H.drop_item(src)
					MYPDA.layer = 22
					H.PDA = MYPDA
					update_slot(MYPDA)

/obj/hud
	backpack
		icon_state = "backpack"
		screen_loc = "SOUTH-1, WEST+6"
		var/image/backoverlay
		screen_loc = "WEST+1, SOUTH"
		invisibility = 101

		Click()
			var/mob/simulated/living/humanoid/H = iam
			var/obj/item/I = H.get_active_hand()
			var/obj/item/weapon/storage/box/backpack/myback = I
			if(myback && istype(myback,/obj/item/weapon/storage/box/backpack))
				if(H.back == null)
					if(backoverlay)
						backoverlay.layer = initial(backoverlay.layer)
					H.drop_item(src)
					myback.layer = 22
					H.back = myback
					myback.jetpacked = iam
					if(H.gender == "male")
						backoverlay = image('suit.dmi',icon_state = myback.icon_state)
					else
						backoverlay = image('suit.dmi',icon_state = "[myback.icon_state]_fem")
					backoverlay.layer = 23
					H.overlays += backoverlay
					update_slot(myback)

/obj/hud
	switcher
		icon_state = "switcher"
		screen_loc = "SOUTH-1, WEST+5"
		invisibility = 101

		Click()
			var/mob/simulated/living/humanoid/H = iam
			flick("switcher_flick", src)
			if(cur_cloth_slot == 1) //cloth
				cur_cloth_slot = 0 //id
				H.CL.invisibility = 101
				H.BP.invisibility = 101
				if(H.cloth)
					H.cloth.invisibility = 101
				if(H.back)
					H.back.invisibility = 101
				H.ID.invisibility = 0
				if(H.id)
					H.id.invisibility = 0
				return
			if(cur_cloth_slot == 0) //id
				cur_cloth_slot = -1 //backpack
				H.ID.invisibility = 101
				H.CL.invisibility = 101
				H.BP.invisibility = 0
				if(H.id)
					H.id.invisibility = 101
				if(H.cloth)
					H.cloth.invisibility = 101
				if(H.back)
					H.back.invisibility = 0
				return
			else
				cur_cloth_slot = 1 //cloth
				H.BP.invisibility = 101
				H.ID.invisibility = 101
				if(H.id)
					H.id.invisibility = 101
				if(H.back)
					H.back.invisibility = 101
				H.CL.invisibility = 0
				if(H.cloth)
					H.cloth.invisibility = 0
				return
				 //top feature