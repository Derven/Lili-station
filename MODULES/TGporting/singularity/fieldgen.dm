
/*
field_generator power level display
   The icon used for the field_generator need to have 'num_power_levels' number of icon states
   named 'Field_Gen +p[num]' where 'num' ranges from 1 to 'num_power_levels'

   The power level is displayed using overlays. The current displayed power level is stored in 'powerlevel'.
   The overlay in use and the powerlevel variable must be kept in sync.  A powerlevel equal to 0 means that
   no power level overlay is currently in the overlays list.
   -Aygar
*/

#define field_generator_max_power 250
/obj/machinery/field_generator
	name = "Field Generator"
	desc = "A large thermal battery that projects a high amount of energy when powered."
	icon = 'stationobjs.dmi'
	icon_state = "field_generator"
	anchored = 0
	density = 1
	use_power = 0
	var
		const/num_power_levels = 15  // Total number of power level icon has
		Varedit_start = 0
		Varpower = 0
		active = 0
		power = 20  // Current amount of power
		state = 0
		warming_up = 0
		powerlevel = 0  // Current Power level in overlays list
		list/obj/machinery/containment_field/fields
		list/obj/machinery/field_generator/connected_gens
		clean_up = 0

	New()
		..()
		fields = list()
		connected_gens = list()
		return


	process()
		if(Varedit_start == 1)
			if(active == 0)
				active = 1
				state = 2
				power = field_generator_max_power
				anchored = 1
				warming_up = 3
				turn_on()
			Varedit_start = 0

		if(src.active == 2)
			calc_power()
			update_icon()
		return


	attack_hand(mob/user as mob)
		if(get_dist(src, user) <= 1)//Need to actually touch the thing to turn it on
			if(src.active >= 1)
				user << "You are unable to turn off the [src.name] once it is online."
				return 1
			else
				user << "[user.name] turns on the [src.name]"
				turn_on()

	bullet_act(var/obj/item/projectile/Proj)
		if(Proj.flag != "bullet")
			power += Proj.damage
			update_icon()
			del(Proj)
		return 0


	Del()
		src.cleanup()
		..()


	proc
		turn_off()
			active = 0
			spawn(1)
				src.cleanup()
			update_icon()


		turn_on()
			active = 1
			warming_up = 1
			spawn(1)
				while (warming_up<3 && active)
					sleep(50)
					warming_up++
					update_icon()
					if(warming_up >= 3)
						start_fields()
			update_icon()


		calc_power()
			if(Varpower)
				return 1

			update_icon()
			if(src.power > field_generator_max_power)
				src.power = field_generator_max_power

			var/power_draw = 2
			for (var/obj/machinery/containment_field/F in fields)
				if (isnull(F))
					continue
				power_draw++
			if(draw_power(round(power_draw/2,1)))
				return 1
			else
				for(var/mob/M in viewers(src))
					M.show_message("\red The [src.name] shuts down!")
				turn_off()
				src.power = 0
				return 0

//This could likely be better, it tends to start loopin if you have a complex generator loop setup.  Still works well enough to run the engine fields will likely recode the field gens and fields sometime -Mport
		draw_power(var/draw = 0, var/failsafe = 0, var/obj/machinery/field_generator/G = null, var/obj/machinery/field_generator/last = null)
			if(Varpower)
				return 1
			if((G && G == src) || (failsafe >= 8))//Loopin, set fail
				return 0
			else
				failsafe++
			if(src.power >= draw)//We have enough power
				src.power -= draw
				return 1
			else//Need more power
				draw -= src.power
				src.power = 0
				for(var/obj/machinery/field_generator/FG in connected_gens)
					if(isnull(FG))
						continue
					if(FG == last)//We just asked you
						continue
					if(G)//Another gen is askin for power and we dont have it
						if(FG.draw_power(draw,failsafe,G,src))//Can you take the load
							return 1
						else
							return 0
					else//We are askin another for power
						if(FG.draw_power(draw,failsafe,src,src))
							return 1
						else
							return 0


		start_fields()
			spawn(1)
				setup_field(1)
			spawn(2)
				setup_field(2)
			spawn(3)
				setup_field(4)
			spawn(4)
				setup_field(8)
			src.active = 2


		setup_field(var/NSEW)
			var/turf/T = src.loc
			var/obj/machinery/field_generator/G
			var/steps = 0
			if(!NSEW)//Make sure its ran right
				return
			for(var/dist = 0, dist <= 9, dist += 1) // checks out to 8 tiles away for another generator
				T = get_step(T, NSEW)
				if(T.density)//We cant shoot a field though this
					return 0
				for(var/atom/A in T.contents)
					if(ismob(A))
						continue
				steps += 1
				G = locate(/obj/machinery/field_generator) in T
				if(!isnull(G))
					steps -= 1
					if(!G.active)
						return 0
					break
			if(isnull(G))
				return
			T = src.loc
			for(var/dist = 0, dist < steps, dist += 1) // creates each field tile
				var/field_dir = get_dir(T,get_step(G.loc, NSEW))
				T = get_step(T, NSEW)
				if(!locate(/obj/machinery/containment_field) in T)
					var/obj/machinery/containment_field/CF = new/obj/machinery/containment_field()
					CF.set_master(src,G)
					fields += CF
					G.fields += CF
					CF.loc = T
					CF.dir = field_dir
			var/listcheck = 0
			for(var/obj/machinery/field_generator/FG in connected_gens)
				if (isnull(FG))
					continue
				if(FG == G)
					listcheck = 1
					break
			if(!listcheck)
				connected_gens.Add(G)
			listcheck = 0
			for(var/obj/machinery/field_generator/FG2 in G.connected_gens)
				if (isnull(FG2))
					continue
				if(FG2 == src)
					listcheck = 1
					break
			if(!listcheck)
				G.connected_gens.Add(src)


		cleanup()
			clean_up = 1
			for (var/obj/machinery/containment_field/F in fields)
				if (isnull(F))
					continue
				del(F)
			fields = list()
			for(var/obj/machinery/field_generator/FG in connected_gens)
				if (isnull(FG))
					continue
				FG.connected_gens.Remove(src)
				connected_gens.Remove(FG)
			connected_gens = list()
			clean_up = 0
