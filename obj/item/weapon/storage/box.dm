/obj/item/weapon/storage/box
	name = "box"
	icon = 'tools.dmi'
	icon_state = "box"

	attackby(var/obj/item/I)
		if(!istype(I, /obj/item/weapon/storage))
			usr.drop_item(src)
			I.Move(src)
			usr << usr.select_lang("Вы положили [I] в коробку!", "You put [I] into box!")