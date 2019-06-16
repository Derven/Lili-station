/obj/structure/closet
	medcloset
		name = "medical closet"
		desc = "It's a closet for medical supplies."
		icon = 'closet.dmi'
		icon_state = "med_closed"
		icon_closed = "med_closed"
		icon_opened = "med_open"

	sec
		name = "security closet"
		desc = "It's a closet for the storage of security equipment."
		icon = 'closet.dmi'
		icon_state = "sec_closed"
		icon_closed = "sec_closed"
		icon_opened = "sec_open"

	eng
		name = "engineering closet"
		desc = "It's a closet for the storage of engenireeng equipment."
		icon = 'closet.dmi'
		icon_state = "eng_closed"
		icon_closed = "eng_closed"
		icon_opened = "eng_open"

	oxygen
		name = "closet"
		desc = "It's a closet!"
		icon_state = "oxygen"
		icon_closed = "oxygen"
		icon_opened = "oxygen_open"

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

		coffin
			name = "coffin"
			desc = "It's a coffin!"
			icon_state = "coffin"
			icon_closed = "coffin"
			icon_opened = "coffin_open"

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
