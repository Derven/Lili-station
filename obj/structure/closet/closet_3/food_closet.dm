/obj/structure/closet
	closet_3
		anchored = 1
		name = "Closet"
		desc = "It's a closet!"
		icon = 'closet.dmi'
		icon_state = "polka_0"

		proc/upd_closet()
			if(contents.len == 0)
				icon_state = "polka_0"
			if(contents.len > 0)
				icon_state = "polka_1"

		attack_hand()
			return

		attackby(var/obj/item/I)
			usr.drop_item(src)
			I.Move(src)
			icon_state = "polka_1"

		food_closet
			icon_state = "polka_1"

			New()
				..()
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)