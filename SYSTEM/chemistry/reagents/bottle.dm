/obj/item/weapon/reagent_containers/glass/bottle/tric
	name = "tricordrazine bottle"
	desc = "A small bottle of tricordrazine"
	icon = 'chemical.dmi'
	icon_state = "bottle"

	New()
		..()
		reagents.add_reagent("tricordrazine", 40)

/obj/item/weapon/reagent_containers/glass/bottle/milk
	name = "milk bottle"
	desc = "A small bottle of milk."
	icon = 'chemical.dmi'
	icon_state = "bottle"

	New()
		..()
		reagents.add_reagent("milk", 40)

/obj/item/weapon/reagent_containers/glass/bottle/cola
	name = "cola"
	desc = "space cola"
	icon = 'chemical.dmi'
	icon_state = "cola"

	New()
		..()
		reagents.add_reagent("cola", 40)

/obj/item/weapon/reagent_containers/glass/bottle/energy_gun
	name = "energy gun"
	desc = "space energy drink"
	icon = 'chemical.dmi'
	icon_state = "mutagen"

	New()
		..()
		reagents.add_reagent("cola", 20)
		reagents.add_reagent("caffeine", 20)

/obj/item/weapon/reagent_containers/glass/bottle/nutriments
	name = "nutriments"
	desc = "space nutriments"
	icon = 'chemical.dmi'
	icon_state = "nutriment"

	New()
		..()
		reagents.add_reagent("nutriments", 10)

/obj/item/weapon/reagent_containers/glass/bottle/mutagen
	name = "mutagen"
	desc = "space mutagen"
	icon = 'chemical.dmi'
	icon_state = "mutagen"

	New()
		..()
		reagents.add_reagent("mutagen", 10)

/obj/item/weapon/reagent_containers/glass/bottle/water
	name = "water"
	desc = "space water"
	icon = 'chemical.dmi'
	icon_state = "drink_bottle"

	New()
		..()
		reagents.add_reagent("water", 10)

/obj/item/weapon/reagent_containers/glass/bottle/watercan
	name = "watercan"
	icon = 'chemical.dmi'
	icon_state = "watercan"

/obj/item/weapon/reagent_containers/glass/bottle/bucket
	name = "bucket"
	icon = 'chemical.dmi'
	icon_state = "bucket"

	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/weapon/mop))
			if(reagents.has_reagent("water", 10))
				reagents.remove_reagent("water", 10)
				user << "You wet the mop!"
				var/obj/item/weapon/mop/M = I
				M.watered = 5
		//wrap(I, user)
		return