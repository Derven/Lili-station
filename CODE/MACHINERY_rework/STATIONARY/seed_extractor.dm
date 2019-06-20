/obj/machinery/seed_extractor
	name = "seed extractor"
	desc = "Extracts and bags seeds from produce."
	icon = 'hydroponics.dmi'
	icon_state = "sextractor"
	use_power = 1
	idle_power_usage = 100
	density = 1
	anchored = 1
	var/piles = list()

obj/machinery/seed_extractor/attackby(var/obj/item/O as obj, var/mob/user as mob)

	//Called when mob user "attacks" it with object O
	if (istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown/))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/F = O
		user << "You extract some seeds from the [F.name]"
		var/seed = text2path(F.seed)
		var/t_amount = 0
		var/t_max = rand(1,4)
		while ( t_amount < t_max)
			new seed(src.loc)
			t_amount++
		del(O)
	return

datum/seed_pile
	var/name = ""
	var/lifespan = 0	//Saved stats
	var/endurance = 0
	var/maturation = 0
	var/production = 0
	var/yield = 0
	var/potency = 0
	var/amount = 0

datum/seed_pile/New(var/name, var/life, var/endur, var/matur, var/prod, var/yie, var/poten, var/am = 1)
	src.name = name
	src.lifespan = life
	src.endurance = endur
	src.maturation = matur
	src.production = prod
	src.yield = yie
	src.potency = poten
	src.amount = am

obj/machinery/seed_extractor/proc/add(var/obj/item/seeds/O as obj)
	if(contents.len >= 999)
		usr << "<span class='notice'>\The [src] is full.</span>"
		return 0

	O.loc = src

	for (var/datum/seed_pile/N in piles)
		if (O.plantname == N.name && O.lifespan == N.lifespan && O.endurance == N.endurance && O.maturation == N.maturation && O.production == N.production && O.yield == N.yield && O.potency == N.potency)
			++N.amount
			return

	piles += new /datum/seed_pile(O.plantname, O.lifespan, O.endurance, O.maturation, O.production, O.yield, O.potency)
	return
