/obj/item/weapon/weldingtool
	name = "weldingtool"
	icon = 'tools.dmi'
	icon_state = "welder"
	var/volume = 60

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(volume)
		reagents = R
		R.my_atom = src
		R.add_reagent("diesel", 40)

	proc/use()
		if(reagents.has_reagent("diesel", 10))
			reagents.remove_reagent("diesel", 10, 0)
			return 1
		else
			return 0