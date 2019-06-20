/obj/machinery/computer/diseasesplicer
	name = "Disease Splicer"
	icon = 'virology.dmi'
	icon_state = "splicer"
	broken_icon

	var/datum/microorganism/effectholder/memorybank = null
	var/analysed = 0
	var/obj/item/weapon/virusdish/dish = null
	var/burning = 0

	var/splicing = 0
	var/scanning = 0

/obj/machinery/computer/diseasesplicer/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if(splicing)
		dat = "Splicing in progress"
	else if(scanning)
		dat = "Splicing in progress"
	else if(burning)
		dat = "Data disk burning in progress"
	else
		if(dish)
			dat = "Virus dish inserted"

		dat += "<BR>Current DNA strand : "
		if(memorybank)
			dat += "<A href='?src=\ref[src];splice=1'>"
			if(analysed)
				dat += "[memorybank.effect.name] ([5-memorybank.effect.stage])"
			else
				dat += "Unknown DNA strand ([5-memorybank.effect.stage])"
			dat += "</a>"

			dat += "<BR><A href='?src=\ref[src];disk=1'>Burn DNA Sequence to data storage disk</a>"
		else
			dat += "Empty"

		dat += "<BR><BR>"

		if(dish)
			if(dish.microorganism)
				if(dish.growth >= 50)
					for(var/datum/microorganism/effectholder/e in dish.microorganism.effects)
						dat += "<BR><A href='?src=\ref[src];grab=\ref[e]'> DNA strand"
						if(dish.analysed)
							dat += ": [e.effect.name]"
						dat += " (5-[e.effect.stage])</a>"
				else
					dat += "<BR>Insufficent cells to attempt gene splicing"
			else
				dat += "<BR>No virus found in dish"

			dat += "<BR><BR><A href='?src=\ref[src];eject=1'>Eject disk</a>"
		else
			dat += "<BR>Please insert dish"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/diseasesplicer/process()
	if(stat & (NOPOWER|BROKEN))
		return
	//src.updateDialog()

	if(scanning)
		scanning -= 1
		if(!scanning)
			icon_state = "splicer"
	if(splicing)
		splicing -= 1
		if(!splicing)
			icon_state = "splicer"
	if(burning)
		burning -= 1
		if(!burning)
			var/obj/item/weapon/diseasedisk/d = new /obj/item/weapon/diseasedisk(src.loc)
			if(analysed)
				d.name = "[memorybank.effect.name] GNA disk (Stage: [5-memorybank.effect.stage])"
			else
				d.name = "Unknown GNA disk (Stage: [5-memorybank.effect.stage])"
			d.effect = memorybank
			icon_state = "splicer"


	return

/obj/machinery/computer/diseasesplicer/Topic(href, href_list)
	if(..())
		return
	if (usr.contents.Find(src))
		usr.machine = src

		if (href_list["grab"])
			memorybank = locate(href_list["grab"])
			analysed = dish.analysed
			del(dish)
			dish = null
			scanning = 10
			icon_state = "splicer_processing"

		else if(href_list["eject"])
			dish.loc = src.loc
			dish = null

		else if(href_list["splice"])
			for(var/datum/microorganism/effectholder/e in dish.microorganism.effects)
				if(e.stage == memorybank.stage)
					e.effect = memorybank.effect
			splicing = 10
			dish.microorganism.spreadtype = "Blood"
			icon_state = "splicer_processing"

		else if(href_list["disk"])
			burning = 10
			icon_state = "splicer_processing"

	src.updateUsrDialog()
	return

/obj/item/weapon/diseasedisk
	name = "Blank GNA disk"
	icon = 'tools.dmi'
	icon_state = "datadisk0"
	var/datum/microorganism/effectholder/effect = null
	var/stage = 1

/obj/item/weapon/diseasedisk/premade/New()
	name = "Blank GNA disk (stage: [5-stage])"
	effect = new /datum/microorganism/effectholder
	effect.effect = new /datum/microorganism/effect/invisible
	effect.stage = stage
