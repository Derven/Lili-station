/obj/item/weapon/storage/bag/plants

/obj/item/weapon/storage/box
	name = "box"
	icon = 'tools.dmi'
	icon_state = "box"

	attackby(var/obj/item/I)
		if(!istype(I, /obj/item/weapon/storage))
			usr.drop_item(src)
			I.Move(src)
			usr << usr.select_lang("Вы положили [I] в коробку!", "You put [I] into box!")

/proc/seedify(var/obj/item/O as obj, var/t_max)
	var/t_amount = 0
	if(t_max == -1)
		t_max = rand(1,4)

	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown/))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/F = O
		while(t_amount < t_max)
			var/obj/item/seeds/t_prod = new F.seed(O.loc, O)
			t_prod.lifespan = F.lifespan
			t_prod.endurance = F.endurance
			t_prod.maturation = F.maturation
			t_prod.production = F.production
			t_prod.yield = F.yield
			t_prod.potency = F.potency
			t_amount++
		del(O)
		return 1

	/*else if(istype(O, /obj/item/stack/tile/grass))
		var/obj/item/stack/tile/grass/S = O
		new /obj/item/seeds/grassseed(O.loc)
		S.use(1)
		return 1*/
	else
		return 0


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
		user << user.select_lang("Вы получили сем&#255;на из [F.name]", "You extract some seeds from the [F.name]")
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
