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

