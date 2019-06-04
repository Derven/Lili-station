//Baseline portable generator. Has all the default handling. Not intended to be used on it's own (since it generates unlimited power).
/obj/machinery/power/port_gen
	name = "Portable Generator"
	desc = "A portable generator for emergency backup power"
	icon = 'power.dmi'
	icon_state = "portgen1"
	density = 1
	anchored = 0
	use_power = 0

	var/active = 0
	var/power_gen = 5000
	var/open = 0
	var/recent_fault = 0
	var/power_output = 1
	var/obj/item/stack/uranus/FUEL
	var/iter = 0

	process()
		if(FUEL)
			if(iter < 20)
				for(var/obj/machinery/simple_apc/SA in range(7, src))
					SA.charge += rand(10000, 70000)
					iter += 1
			else
				FUEL = null
				iter = 0

	attackby(obj/item/weapon/W as obj, mob/simulated/living/humanoid/user as mob)
		if(!FUEL)
			if(istype(W, /obj/item/stack/uranus))
				usr:drop_item_v()
				W.Move(src)
				FUEL = W
				usr << "\blue You put [W] in [src]"