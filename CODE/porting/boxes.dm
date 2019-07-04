/mob/var/myjetpack = 0

/obj/item/weapon/storage/box
	name = "box"
	icon = 'tools.dmi'
	icon_state = "box"

	medbox
		icon_state = "medbox"
		New()
			..()
			var/i = rand(2,4)
			while(i > 0)
				i -= 1
				contents += new /obj/item/weapon/reagent_containers/food/snacks/pill/tric_pill()
				contents += new /obj/item/weapon/reagent_containers/food/snacks/pill/kelotane()

	emergency_medbox
		icon_state = "emergencymedbox"
		desc = "A box that can save you."

		New()
			..()
			contents += new /obj/item/weapon/reagent_containers/food/snacks/pill/anti_toxin
			contents += new /obj/item/weapon/reagent_containers/food/snacks/pill/leporazine
			contents += new /obj/item/weapon/reagent_containers/food/snacks/pill/dexalin

	toolbox
		inhandstate = "blue_toolbox"
		New()
			..()
			var/i = rand(2,4)
			while(i > 0)
				i -= 1
				var/type = pick(/obj/item/weapon/wrench, /obj/item/weapon/wirecutters, /obj/item/weapon/weldingtool)
				contents += new type()
			contents += new /obj/item/weapon/crowbar()
	backpack
		icon_state = "backpack"
		name = "backpack"
		var/mob/jetpacked = null

		New()
			..()
			new /obj/item/device/radio(src)

		jetpack
			icon_state = "jetpack"
			attackby(var/obj/item/I)
				return 0

			proc/jpixel()
				var/pixel_j_min = 0
				var/pixel_j_max = 16
				var/oldpixel_j = 0
				if(jetpacked)
					if(oldpixel_j == 0)
						jetpacked.pixel_z = rand(pixel_j_min, pixel_j_max)
					var/newpixel_j = rand(pixel_j_min, pixel_j_max)
					if(abs(oldpixel_j - newpixel_j) <= 2 && abs(oldpixel_j - newpixel_j) > 0)
						jetpacked.pixel_z = newpixel_j

			process()
				if(jetpacked)
					jpixel()
					jetpacked.myjetpack = 1
					if(prob(25))
						new /obj/effect/smoke(jetpacked.loc)

	attackby(var/obj/item/I)
		var/mob/simulated/living/humanoid/user = usr
		if(!istype(I, /obj/item/weapon/storage))
			user.drop_item(src)
			I.Move(src)
			usr << "You put [I] in [src.name]!"

/mob
	var/list/boxes = list()

/obj/item/weapon/storage
	attack_self()
		var/mob/simulated/living/humanoid/user = usr
		//usr.client.screen
		var/i = 0
		var/y = 0
		for(var/obj/item/I in contents)
			if(i > 3)
				y += 1
				i = 0
			var/obj/hud/box/B = new(user)
			B.screen_loc = "SOUTH+[2 + i], WEST+[1 + y]"
			I.screen_loc = B.screen_loc
			I.layer = 22
			B.myitem = I
			user.client.screen.Add(B)
			user.client.screen.Add(I)
			user.boxes.Add(B)
			i += 1

		var/obj/hud/box_close/X = new(user)
		X.screen_loc = "SOUTH+[2 + i], WEST+[2 + y]"
		user.client.screen.Add(X)

