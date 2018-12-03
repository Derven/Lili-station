/obj/machinery/computer/curer
	name = "Cure Research Machine"
	icon = 'virology.dmi'
	icon_state = "curer"
	var/curing
	var/virusing

	var/obj/item/weapon/reagent_containers/container = null

/obj/machinery/computer/curer/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if(curing)
		dat = "Antibody production in progress"
	else if(virusing)
		dat = "Virus production in progress"
	else if(container)
		// see if there's any blood in the container
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in container.reagents.reagent_list

		if(B)
			dat = "Blood sample inserted."
			dat += "<BR><A href='?src=\ref[src];antibody=1'>Begin antibody production</a>"
		else
			dat += "<BR>Please check container contents."
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject container</a>"
	else
		dat = "Please insert a container."

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/curer/process()
	..()

	if(stat & (NOPOWER|BROKEN))
		return
	//src.updateDialog()

	if(curing)
		curing -= 1
		if(curing == 0)
			icon_state = "curer"
			if(container)
				createcure(container)
	return

/obj/machinery/computer/curer/Topic(href, href_list)
	if(..())
		return
	if (usr.contents.Find(src))
		usr.machine = src

		if (href_list["antibody"])
			curing = 10
			src.icon_state = "curer_processing"
		else if(href_list["eject"])
			container.loc = src.loc
			container = null
	return


/obj/machinery/computer/curer/proc/createcure(var/obj/item/weapon/reagent_containers/container)
	var/obj/item/weapon/reagent_containers/glass/beaker/product = new(src.loc)
	product.reagents.add_reagent("antibodies",30)
	var/datum/reagent/blood/B = locate() in container.reagents.reagent_list
	for(var/datum/reagent/antibodies/A in product.reagents.reagent_list)
		if(A.id == "antibodies")
			A.antibodies = B.antibodies

/obj/machinery/computer/curer/proc/createvirus(var/datum/microorganism/disease/microorganism)
	var/obj/item/weapon/cureimplanter/implanter = new /obj/item/weapon/cureimplanter(src.loc)
	implanter.name = "Viral implanter (MAJOR BIOHAZARD)"
	implanter.works = 3