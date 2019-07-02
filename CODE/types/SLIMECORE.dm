/obj/item/weapon/reagent_containers/food/snacks/slimecore/icon = 'slimes.dmi'
/obj/item/weapon/reagent_containers/food/snacks/slimecore/icon_state = "slimecore"
/obj/item/weapon/reagent_containers/food/snacks/slimecore/var/colortype = "gray"

/obj/item/weapon/reagent_containers/food/snacks/slimecore/blue
	colortype = "blue"
	New()
		..()
		reagents.add_reagent("bslime", 5)
		coreinit()

/obj/item/weapon/reagent_containers/food/snacks/slimecore/gray
	colortype = "gray"
	New()
		..()
		reagents.add_reagent("gslime", 5)
		coreinit()

/obj/item/weapon/reagent_containers/food/snacks/slimecore/New()
	..()
	slime_type(src.loc)
	coreinit()
	src.loc = loc.loc

/obj/item/weapon/reagent_containers/food/snacks/slimecore/proc/coreinit()
	switch(colortype)
		if("gray")
			reagents.add_reagent("gslime", 5)
		if("blue")
			src.icon += rgb(0,0,170)
			reagents.add_reagent("bslime", 5)
		if("green")
			src.icon += rgb(0,170,0)
			reagents.add_reagent("grslime", 5)
		if("red")
			src.icon += rgb(170,0,0)
			reagents.add_reagent("rslime", 5)
		if("yellow")
			src.icon += rgb(50,50,0)
			reagents.add_reagent("yslime", 5)
		if("violet")
			src.icon += rgb(50,0,50)
			reagents.add_reagent("vslime", 5)
		if("black")
			src.icon -= rgb(150,150,150)
			reagents.add_reagent("blslime", 5)
		if("brown")
			src.icon += rgb(80,50,0)
			reagents.add_reagent("brslime", 5)
		if("aqua")
			src.icon += rgb(10,0,70)
			reagents.add_reagent("aslime", 5)
		if("orange")
			src.icon += rgb(50,80,0)
			reagents.add_reagent("oslime", 5)

/obj/item/weapon/reagent_containers/food/snacks/slimecore/proc/slime_type(var/mob/simulated/living/slime/S_L_I_M_E)
	colortype = S_L_I_M_E.colortype

