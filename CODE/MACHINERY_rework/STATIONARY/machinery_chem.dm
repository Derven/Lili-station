#define SOLID 1
#define LIQUID 2
#define GAS 3

/obj/machinery/chem_dispenser/
	name = "chem dispenser"
	density = 1
	anchored = 1
	icon = 'stationobjs.dmi'
	icon_state = "dispenser"
	var/energy = 25
	var/max_energy = 75
	var/amount = 30
	var/obj/item/weapon/reagent_containers/glass/beaker
	var/list/dispensable_reagents = list("hydrogen","lithium","blood", "plasma", "vomit", "milk", "carbon", "nitrogen","oxygen","fluorine","sodium","aluminium","silicon","phosphorus","sulfur","chlorine","potassium","iron","copper","mercury","radium","water","ethanol","sugar","acid",)

	attack_hand()
		var/info = {"
		<html>
		<head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"><title>Chemical dispenser</title></head>
		<body><h1>Chem Dispenser:</h1></br>"}

		var/chemtext = ""
		for(var/chemical in dispensable_reagents)
			chemtext += "<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];chem=[chemical]'>[chemical]</a><br><br>"

		chemtext += "<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];detach=ok'>detach</a><br><br>"
		var/part2 = {"
		</body>
		</html>
		"}
		info += chemtext
		info += part2

		usr << browse(info, "window=chem_dispenser")

	attackby(var/obj/item/O as obj, mob/simulated/living/humanoid/user as mob)		//Attack it with an object.
		var/mob/simulated/living/humanoid/H = usr
		if(istype(O, /obj/item/weapon/reagent_containers/glass) && beaker == null)
			beaker = O
			H.drop_item_v()
			O.Move(src)

	Topic(href, href_list)
		if(usr.check_topic(src))
			if(href_list["chem"])
				if(beaker)
					if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
						//user << "\red [target] is full."
						usr << "\red [beaker] is full."
						return
					else
						var/chem = href_list["chem"]
						usr << "You transfered [beaker:amount_per_transfer_from_this] units of [chem]"
						beaker.reagents.add_reagent(href_list["chem"], beaker:amount_per_transfer_from_this)
			if(href_list["detach"] == "ok")
				for(var/obj/O in src.contents)			//Searches through the contents for the jug.
					if(istype(O, /obj/item/weapon/reagent_containers/glass))
						O.loc = get_turf(src)
				beaker = null



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master/
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "mixer0"
	var/beaker = null
	var/mode = 0
	var/condi = 0

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src

	attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/simulated/living/humanoid/user as mob)
		user = usr
		if(!istype(B, /obj/item/weapon/reagent_containers/glass))
			return

		if(src.beaker)
			user << "A beaker is already loaded into the machine."
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the beaker to the machine!"
		src.updateUsrDialog(usr)
		icon_state = "mixer1"

	Topic(href, href_list)
		if(usr.check_topic(src))
			if(stat & BROKEN) return

			usr.machine = src
			if(!beaker) return
			var/datum/reagents/R = beaker:reagents

			if (href_list["analyze"])
				var/dat = ""
				if(!condi)
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
				else
					dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
				usr << browse(dat, "window=chem_master;size=575x400")
				return
			else if (href_list["add1"])
				R.remove_reagent(href_list["add1"], 1) //Remove/add used instead of trans_to since we're moving a specific reagent.
				reagents.add_reagent(href_list["add1"], 1)
			else if (href_list["add5"])
				R.remove_reagent(href_list["add5"], 5)
				reagents.add_reagent(href_list["add5"], 5)
			else if (href_list["add10"])
				R.remove_reagent(href_list["add10"], 10)
				reagents.add_reagent(href_list["add10"], 10)
			else if (href_list["addall"])
				var/temp_amt = R.get_reagent_amount(href_list["addall"])
				reagents.add_reagent(href_list["addall"], temp_amt)
				R.del_reagent(href_list["addall"])
			else if (href_list["remove1"])
				reagents.remove_reagent(href_list["remove1"], 1)
				if(mode) R.add_reagent(href_list["remove1"], 1)
			else if (href_list["remove5"])
				reagents.remove_reagent(href_list["remove5"], 5)
				if(mode) R.add_reagent(href_list["remove5"], 5)
			else if (href_list["remove10"])
				reagents.remove_reagent(href_list["remove10"], 10)
				if(mode) R.add_reagent(href_list["remove10"], 10)
			else if (href_list["removeall"])
				if(mode)
					var/temp_amt = reagents.get_reagent_amount(href_list["removeall"])
					R.add_reagent(href_list["removeall"], temp_amt)
				reagents.del_reagent(href_list["removeall"])
			else if (href_list["toggle"])
				if(mode)
					mode = 0
				else
					mode = 1
			else if (href_list["main"])
				attack_hand(usr)
				return
			else if (href_list["eject"])
				beaker:loc = src.loc
				beaker = null
				reagents.clear_reagents()
				icon_state = "mixer0"
			else if (href_list["createpill"])
				var/name = input(usr,"Name:","Name your pill!",reagents.get_master_reagent_name())
				var/obj/item/weapon/reagent_containers/food/snacks/pill/P = new/obj/item/weapon/reagent_containers/food/snacks/pill(src.loc)
				if(!name || name == " ") name = reagents.get_master_reagent_name()
				P.name = "[name] pill"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				reagents.trans_to(P,50)
			else if (href_list["createbottle"])
				var/name = input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name())
				var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				if(!name || name == " ") name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				reagents.trans_to(P,30)
			else
				usr << browse(null, "window=chem_master")
			src.updateUsrDialog(usr)
			return

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
			return
		user.machine = src
		var/dat = ""
		if(!beaker)
			dat = "Please insert beaker.<BR>"
			dat += "<A href='?src=\ref[src];close=1'>Close</A>"
		else
			var/datum/reagents/R = beaker:reagents
			dat += "<A href='?src=\ref[src];eject=1'>Eject beaker and Clear Buffer</A><BR><BR>"
			if(!R.total_volume)
				dat += "Beaker is empty."
			else
				dat += "Add to buffer:<BR>"
				for(var/datum/reagent/G in R.reagent_list)
					dat += "[G.name] , [G.volume] Units - "
					dat += "<A href='?src=\ref[src];analyze=1;desc=[G.description];name=[G.name]'>(Analyze)</A> "
					dat += "<A href='?src=\ref[src];add1=[G.id]'>(1)</A> "
					if(G.volume >= 5) dat += "<A href='?src=\ref[src];add5=[G.id]'>(5)</A> "
					if(G.volume >= 10) dat += "<A href='?src=\ref[src];add10=[G.id]'>(10)</A> "
					dat += "<A href='?src=\ref[src];addall=[G.id]'>(All)</A><BR>"
			if(!mode)
				dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>disposal:</A><BR>"
			else
				dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>beaker:</A><BR>"
			if(reagents.total_volume)
				for(var/datum/reagent/N in reagents.reagent_list)
					dat += "[N.name] , [N.volume] Units - "
					dat += "<A href='?src=\ref[src];analyze=1;desc=[N.description];name=[N.name]'>(Analyze)</A> "
					dat += "<A href='?src=\ref[src];remove1=[N.id]'>(1)</A> "
					if(N.volume >= 5) dat += "<A href='?src=\ref[src];remove5=[N.id]'>(5)</A> "
					if(N.volume >= 10) dat += "<A href='?src=\ref[src];remove10=[N.id]'>(10)</A> "
					dat += "<A href='?src=\ref[src];removeall=[N.id]'>(All)</A><BR>"
			else
				dat += "Empty<BR>"
			if(!condi)
				dat += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pill (50 units max)</A><BR>"
				dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (30 units max)</A>"
			else
				dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (50 units max)</A>"
		if(!condi)
			user << browse("<TITLE>Chemmaster 3000</TITLE>Chemmaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
		else
			user << browse("<TITLE>Condimaster 3000</TITLE>Condimaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
		onclose(user, "chem_master")
		return


/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder
	name = "Reagent Grinder"
	icon = 'kitchen.dmi'
	icon_state = "juicer1"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	var/obj/item/weapon/reagent_containers/beaker = null
	var/global/list/allowed_items = list ( // reagent = amount, amount of 0 indicate to determine the amount from the reagents list, only implemented on plants for now
/*
		/obj/item/weapon/reagent_containers/food/snacks/grown/banana = list("banana" = 0),
		/obj/item/weapon/reagent_containers/food/snacks/grown/carrot = list("imidazoline" = 0),
		/obj/item/weapon/reagent_containers/food/snacks/grown/corn = list("cornoil" = 0),
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap = list("psilocybin" = 0),
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/amanita = list("amatoxin" = 0, "psilocybin" = 0),
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/angel = list("amatoxin" = 0, "psilocybin" = 0),
		/obj/item/weapon/reagent_containers/food/snacks/grown/chili = list("capsaicin" = 0),
		/obj/item/weapon/reagent_containers/food/snacks/grown/icepepper = list("frostoil" = 0),
*/
	)

/obj/machinery/reagentgrinder/New()
	..()
	beaker = new /obj/item/weapon/reagent_containers/glass(src)
	return

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return


/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/simulated/living/humanoid/user as mob)
	user = usr
	if (istype(O,/obj/item/weapon/reagent_containers/glass))
		if (beaker)
			return 1
		else
			src.beaker =  O
			user.drop_item()
			O.loc = src
			src.verbs += /obj/machinery/reagentgrinder/verb/detach
			update_icon()
			src.updateUsrDialog(usr)
			return 0
	if (!(O in allowed_items))
		user << "Cannot refine into a reagent."
		return 1
	O.loc = src
	src.updateUsrDialog(usr)
	return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
	user.machine = src
	interact(user)

/obj/machinery/reagentgrinder/proc/interact(mob/user as mob) // The microwave Menu
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""

	for (var/i in allowed_items)
		for (var/obj/item/O in src.contents)
			if (!istype(O,i))
				continue
			processing_chamber+= "some <B>[O]</B><BR>"
			break
	if (!processing_chamber)
		is_chamber_empty = 1
		processing_chamber = "Nothing."
	if (!beaker)
		beaker_contents = "\The [src] has no beaker attached."
	else if (!beaker.reagents.total_volume)
		beaker_contents = "\The [src]  has attached an empty beaker."
		is_beaker_ready = 1
	else if (beaker.reagents.total_volume < beaker.reagents.maximum_volume)
		beaker_contents = "\The [src]  has attached a beaker with something."
		is_beaker_ready = 1
	else
		beaker_contents = "\The [src]  has attached a beaker and the beaker is full!"

	var/dat = {"
<b>Processing chamber contains:</b><br>
[processing_chamber]<br>
[beaker_contents]<hr>
"}
	if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
		dat += "<A href='?src=\ref[src];action=grind'>Turn on!<BR>"
	if (beaker)
		dat += "<A href='?src=\ref[src];action=detach'>Detach a beaker!<BR>"
	user << browse("<HEAD><TITLE>Reagent Grinder</TITLE></HEAD><TT>[dat]</TT>", "window=reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return
	if(usr.check_topic(src))
		usr.machine = src
		switch(href_list["action"])
			if ("grind")
				grind()

			if ("detach")
				detach()
		src.updateUsrDialog(usr)
		return

/obj/machinery/reagentgrinder/verb/detach()
	set category = "Object"
	set name = "Detach Beaker from the grinder"
	set src in oview(1)
	if (usr.stat != 0)
		return
	if (!beaker)
		return
	src.verbs -= /obj/machinery/reagentgrinder/verb/detach
	beaker.loc = src.loc
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/get_allowed_by_id(var/obj/item/weapon/grown/O)
	for (var/i in allowed_items)
		if (istype(O, i))
			return allowed_items[i]

/obj/machinery/reagentgrinder/proc/get_grind_id(var/obj/item/stack/O)
	for (var/i in allowed_items)
		if (istype(O, i))
			return allowed_items[i]

/obj/machinery/reagentgrinder/proc/get_grind_amount(var/obj/item/stack/sheet/O)
	return 20

/obj/machinery/reagentgrinder/proc/grind()
	if (!beaker || beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
		return
	for (var/obj/item/weapon/reagent_containers/food/snacks/O in src.contents)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/allowed = get_allowed_by_id(O)
		for (var/r_id in allowed)
			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			if (amount == 0)
				if (O.reagents != null && O.reagents.has_reagent(r_id))
					beaker.reagents.add_reagent(r_id,min(O.reagents.get_reagent_amount(r_id), space))
			else
				beaker.reagents.add_reagent(r_id,min(amount, space))

			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
		del(O)
	for (var/obj/item/stack/O in src.contents)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
	for (var/obj/item/weapon/grown/O in src.contents)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/allowed = get_allowed_by_id(O)
		for (var/r_id in allowed)
			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			if (amount == 0)
				if (O.reagents != null && O.reagents.has_reagent(r_id))
					beaker.reagents.add_reagent(r_id,min(O.reagents.get_reagent_amount(r_id), space))
			else
				beaker.reagents.add_reagent(r_id,min(amount, space))

			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
		del(O)