/obj/machinery/smelter
	name = "ore smelter"
	icon = 'stationobjs.dmi'
	icon_state = "smelter"

	attackby(obj/item/weapon/W as obj, mob/simulated/living/humanoid/user as mob)
		if(istype(W, /obj/item/stack/metalore))
			usr << "You smelt the ore..." ///hhmmm
			if(do_after(usr, 5))
				user.drop_item_v()
				del(W)
				new /obj/item/stack/metal(src.loc)