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

	attackby(var/obj/item/I)
		if(!istype(I, /obj/item/weapon/storage))
			usr.drop_item(src)
			I.Move(src)
			usr << usr.select_lang("Вы положили [I] в коробку!", "You put [I] into box!")

/mob
	var/list/boxes = list()

/obj/item/weapon/storage
	attack_self()
		//usr.client.screen
		var/i = 0
		for(var/obj/item/I in contents)
			var/obj/hud/box/B = new(usr)
			B.screen_loc = "SOUTH+[1 + i], WEST+1"
			I.screen_loc = B.screen_loc
			I.layer = 21
			B.myitem = I
			usr.client.screen.Add(B)
			usr.client.screen.Add(I)
			usr.boxes.Add(B)
			i += 1
		var/obj/hud/box_close/X = new(usr)
		X.screen_loc = "SOUTH+[1 + i], WEST+1"
		usr.client.screen.Add(X)

