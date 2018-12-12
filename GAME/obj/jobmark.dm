//ok
/obj/jobmark
	icon = 'landmarks.dmi'

	New()
		..()
		invisibility = 101
		jobmarks += src.loc

/obj/syndibotspawn
	icon = 'landmarks.dmi'

	New()
		..()
		invisibility = 101

	process()
		if(prob(4))
			var/obj/critter/C = pick(/obj/critter/killertomato/fox_on_bike/syndi1, /obj/critter/killertomato/fox_on_bike/syndi2)
			new C(src.loc)