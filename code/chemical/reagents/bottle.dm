/obj/item/weapon/reagent_containers/glass/bottle/nutriments
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon = 'chemical.dmi'
	icon_state = "bottle"

	New()
		..()
		reagents.add_reagent("nutriments", 40)

/obj/item/weapon/reagent_containers/glass/bottle/milk
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon = 'chemical.dmi'
	icon_state = "bottle"

	New()
		..()
		reagents.add_reagent("milk", 40)