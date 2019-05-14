/obj/structure/closet
	medcloset
		name = "medical closet"
		desc = "It's a closet for medical supplies."
		icon = 'closet.dmi'
		icon_state = "medclosed"
		icon_closed = "medclosed"
		icon_opened = "medclosed_open"

	sec
		name = "security closet"
		desc = "It's a closet for the storage of security equipment."
		icon = 'closet.dmi'
		icon_state = "sec"
		icon_closed = "sec"
		icon_opened = "open"

	oxygen
		name = "closet"
		desc = "It's a closet!"
		icon_state = "oxygen"
		icon_closed = "oxygen"
		icon_opened = "open"

		New()
			..()
			new /obj/item/clothing/suit/NTspace(src)

	crate
		climbcan = 1
		name = "crate"
		desc = "It's a crate!"
		icon_state = "crate"
		icon_closed = "crate"
		icon_opened = "crate_open"

		shaft
			New()
				..()
				new /obj/item/clothing/suit/soviet(src)
				new /obj/item/clothing/suit/soviet(src)
				new /obj/item/clothing/suit/soviet(src)

	oxycrate
		name = "blue crate"
		icon_state = "crate_oxygen"
		icon_closed = "crate_oxygen"
		icon_opened = "crate_open"

		New()
			..()
			new /obj/item/clothing/suit/NTspace(src)

	hydcrate
		name = "green crate"
		icon_state = "crate_hydro"
		icon_closed = "crate_hydro"
		icon_opened = "crate_open"
