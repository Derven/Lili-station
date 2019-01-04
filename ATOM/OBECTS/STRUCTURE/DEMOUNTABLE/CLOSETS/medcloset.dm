/obj/structure/closet
	medcloset
		name = "Closet"
		desc = "It's a closet!"
		icon = 'closet.dmi'
		icon_state = "medclosed"
		icon_closed = "medclosed"
		icon_opened = "open"

	oxygen
		name = "Closet"
		desc = "It's a closet!"
		icon = 'closet.dmi'
		icon_state = "oxygen"
		icon_closed = "oxygen"
		icon_opened = "open"

		New()
			..()
			new /obj/item/clothing/suit/NTspace(src)

	crate
		name = "crate"
		desc = "It's a crate!"
		icon = 'closet.dmi'
		icon_state = "crate"
		icon_closed = "crate"
		icon_opened = "crate_open"

		antimatter
			New()
				..()
				new /obj/item/weapon/fuel/H(src)
				new /obj/item/weapon/fuel/H(src)
				new /obj/item/weapon/fuel/H(src)
				new /obj/item/weapon/fuel/antiH(src)
				new /obj/item/weapon/fuel/antiH(src)
				new /obj/item/weapon/fuel/antiH(src)

		shaft
			New()
				..()
				new /obj/item/clothing/suit/soviet(src)
				new /obj/item/clothing/suit/soviet(src)
				new /obj/item/clothing/suit/soviet(src)

	oxycrate
		name = "blue crate"
		desc = "It's a crate!"
		icon = 'closet.dmi'
		icon_state = "crate_oxygen"
		icon_closed = "crate_oxygen"
		icon_opened = "crate_open"

		New()
			..()
			new /obj/item/clothing/suit/NTspace(src)

	hydcrate
		name = "green crate"
		desc = "It's a crate!"
		icon = 'closet.dmi'
		icon_state = "crate_hydro"
		icon_closed = "crate_hydro"
		icon_opened = "crate_open"


/obj/structure/closet
	sec
		name = "Closet"
		desc = "It's a closet!"
		icon = 'closet.dmi'
		icon_state = "sec"
		icon_closed = "sec"
		icon_opened = "open"