/obj/machinery/smelter
	icon = 'stationobjs.dmi'
	icon_state = "smelter"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/stack/metalore))
			usr << usr.select_lang("Вы плавите руду", "You smelt ore...")
			if(do_after(usr, 5))
				usr.drop_item_v()
				del(W)
				new /obj/item/stack/metal(src.loc)