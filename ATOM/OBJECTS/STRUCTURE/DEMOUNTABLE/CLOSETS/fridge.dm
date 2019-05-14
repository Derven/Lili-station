/obj/structure/closet

	fridge
		icon = 'fridge.dmi'

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

		morgue
			icon = 'closet.dmi'
			icon_state = "morgue"
			icon_opened = "morgue_open"
			icon_closed = "morgue"
			pixel_z = 2
			anchored = 1

			New()
				..()

			close()
				src.icon_closed = "morgue"
				for(var/mob/M in range(5, src))
					M.playsoundforme('bin_open.ogg')
				if(!src.opened)
					return 0
				if(!src.can_close())
					return 0

				for(var/obj/item/I in src.loc)
					if(!I.anchored)
						I.loc = src

				for(var/mob/M in src.loc)
					src.icon_closed = "morgue_full"
					if(M.client)
						M.client.perspective = EYE_PERSPECTIVE
						M.client.eye = src


					M.loc = src

				src.icon_state = src.icon_closed
				src.opened = 0
				////playsound(src.loc, 'click.ogg', 15, 1, -3)
				density = 1
				return 1