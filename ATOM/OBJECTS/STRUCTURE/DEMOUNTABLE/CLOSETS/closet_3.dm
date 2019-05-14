/obj/structure/closet
	closet_3
		anchored = 1
		name = "closet_3"
		desc = "It's a closet!"
		icon = 'closet.dmi'
		icon_state = "polka_0"


		proc/upd_closet()
			if(contents.len == 0)
				icon_state = "polka_0"
			if(contents.len > 0)
				icon_state = "polka_1"

		attack_hand()
			return

		attackby(var/obj/item/I, mob/simulated/living/humanoid/user as mob)
			user.drop_item(src)
			I.Move(src)
			icon_state = "polka_1"

/obj/structure/closet
	books
		anchored = 1
		name = "books"
		desc = "It's a closet!"
		icon = 'closet.dmi'
		icon_state = "books1"


		proc/upd_closet()
			if(contents.len == 0)
				icon_state = "books2"
			if(contents.len > 0)
				icon_state = "books1"

		attack_hand()
			return

		attackby(var/obj/item/I, mob/simulated/living/humanoid/user as mob)
			user.drop_item(src)
			I.Move(src)
			icon_state = "books1"