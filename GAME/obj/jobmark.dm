//ok
var/list/meteormarks = list()

/obj/jobmark
	icon = 'landmarks.dmi'
	var/job = "assistant"

	New()
		..()
		invisibility = 101
		jobmarks += src.loc

/obj/syndibotspawn
	icon = 'landmarks.dmi'

	New()
		..()
		invisibility = 101
/*
	process()
		if(prob(4))
			if(fun.cur_event == "syndi sabotage")
				var/obj/critter/C = pick(/obj/critter/killertomato/fox_on_bike/syndi1, /obj/critter/killertomato/fox_on_bike/syndi2)
				new C(src.loc)
*/
/obj/meteorspawn
	icon = 'landmarks.dmi'

	New()
		..()
		invisibility = 101
		meteormarks.Add(src)