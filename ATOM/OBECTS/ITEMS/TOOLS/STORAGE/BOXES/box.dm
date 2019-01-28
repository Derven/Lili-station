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

	toolbox
		New()
			..()
			var/i = rand(2,4)
			while(i > 0)
				i -= 1
				var/type = pick(/obj/item/weapon/wrench, /obj/item/weapon/wirecutters, /obj/item/weapon/weldingtool)
				contents += new type()
	backpack
		icon_state = "backpack"
		var/mob/jetpacked = null

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
					for(var/mob/M in range(5, jetpacked))
						M << 'smoke.ogg'

	attackby(var/obj/item/I)
		var/mob/simulated/living/humanoid/user = usr
		if(!istype(I, /obj/item/weapon/storage))
			user.drop_item(src)
			I.Move(src)
			usr << "You put [I] into box!"

/mob
	var/list/boxes = list()

/obj/item/weapon/storage
	attack_self()
		var/mob/simulated/living/humanoid/user = usr
		//usr.client.screen
		var/i = 0
		for(var/obj/item/I in contents)
			var/obj/hud/box/B = new(user)
			B.screen_loc = "SOUTH+[1 + i], WEST+1"
			I.screen_loc = B.screen_loc
			I.layer = 21
			B.myitem = I
			user.client.screen.Add(B)
			user.client.screen.Add(I)
			user.boxes.Add(B)
			i += 1
		var/obj/hud/box_close/X = new(user)
		X.screen_loc = "SOUTH+[1 + i], WEST+1"
		user.client.screen.Add(X)

