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