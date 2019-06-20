/obj/item/clothing/id
	var/datum/id/ID
	var/idtype
	icon = 'suit.dmi'
	icon_state = "id"
	var/list/myids = list()
	var/credits = 0
	var/cubits = 0
	var/password = 0

	New()
		..()
		ID = new /datum/id (src)
		ids += 1
		password = rand(1000,9990)
		credits = rand(500, 700)
		desc = "[name];[password]"

	captain
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/captain)
			var/datum/id/ID1 = myids[1]
			ID = new ID1(src)
			credits = rand(1500, 2500)
			desc = "[name];[password]"

	assistant
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/assistant)
			var/datum/id/ID1 = myids[1]
			ID = new ID1(src)
			credits = rand(300, 500)
			desc = "[name];[password]"

	doctor
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/doctor)
			var/datum/id/ID1 = myids[1]
			ID = new ID1(src)
			credits = rand(500, 850)
			desc = "[name];[password]"

	security
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/security)
			var/datum/id/ID1 = myids[1]
			ID = new ID1(src)
			credits = rand(700, 1200)
			desc = "[name];[password]"