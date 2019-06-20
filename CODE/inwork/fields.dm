/obj/machinery/containment_field
	name = "Containment Field"
	desc = "An energy field."
	icon = 'stationobjs.dmi'
	icon_state = "e_line"
	anchored = 1
	density = 0
	unacidable = 1
	use_power = 0
	var
		obj/machinery/field_generator/FG1 = null
		obj/machinery/field_generator/FG2 = null

	Del()
		if(FG1 && !FG1.clean_up)
			FG1.cleanup()
		if(FG2 && !FG2.clean_up)
			FG2.cleanup()
		..()

	attack_hand(mob/user as mob)
		if(get_dist(src, user) > 1)
			return 0
		else
			shock(user)
			return 1

	ex_act(severity)
		return 0

	proc
		shock(mob as mob)
			return

		set_master(var/master1,var/master2)
			if(!master1 || !master2)
				return 0
			FG1 = master1
			FG2 = master2
			return 1