/obj/item/device/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	name = "analyzer"
	icon = 'tools.dmi'
	icon_state = "analyser"
	item_state = "analyzer"
	w_class = 2.0
	flags = FPRINT | TABLEPASS| CONDUCT
	m_amt = 30
	g_amt = 20
	origin_tech = "magnets=1;engineering=1"

/obj/item/device/analyzer/attack_self()

	var/mob/simulated/living/humanoid/user = usr
	if (user.stat)
		return
	if (!(istype(usr, /mob/simulated/living/humanoid)))
		usr << "\red You don't have the dexterity to do this!"
		return

	var/turf/location = user.loc
	if (!( istype(location, /turf) ))
		return

	var/datum/gas_mixture/environment = location.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	user.show_message("\blue <B>Results:</B>", 1)
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		user.show_message("\blue Pressure: [round(pressure,0.1)] kPa", 1)
	else
		user.show_message("\red Pressure: [round(pressure,0.1)] kPa", 1)
	if(total_moles)
		var/o2_concentration = environment.oxygen/total_moles
		var/n2_concentration = environment.nitrogen/total_moles
		var/co2_concentration = environment.carbon_dioxide/total_moles
		var/plasma_concentration = environment.toxins/total_moles

		var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)
		if(abs(n2_concentration - N2STANDARD) < 20)
			user.show_message("\blue Nitrogen: [round(n2_concentration*100)]%", 1)
		else
			user.show_message("\red Nitrogen: [round(n2_concentration*100)]%", 1)

		if(abs(o2_concentration - O2STANDARD) < 2)
			user.show_message("\blue Oxygen: [round(o2_concentration*100)]%", 1)
		else
			user.show_message("\red Oxygen: [round(o2_concentration*100)]%", 1)

		if(co2_concentration > 0.01)
			user.show_message("\red CO2: [round(co2_concentration*100)]%", 1)
		else
			user.show_message("\blue CO2: [round(co2_concentration*100)]%", 1)

		if(plasma_concentration > 0.01)
			user.show_message("\red Plasma: [round(plasma_concentration*100)]%", 1)

		if(unknown_concentration > 0.01)
			user.show_message("\red Unknown: [round(unknown_concentration*100)]%", 1)

		user.show_message("\blue Temperature: [round(environment.temperature-T0C)]&deg;C", 1)

	return

/obj/item/device/injector_control
	name = "injector control device"
	icon = 'tools.dmi'
	icon_state = "atmos_control"
	var/body

	attack_self()
		body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
		body += "<body>Injector system consol:<hr><table class=\"pure-table\"><thead><tr><th>Injector</th><th>Coordinates</th></tr></thead><tbody>"
		for(var/obj/machinery/atmospherics/unary/outlet_injector/OI in world)
			body += "<tr><td>injector #<a href='?src=\ref[src];oid=[OI.id];'>[OI.id];[OI.name];[OI.on == 1 ? "On" : "Off"]</a></td><td>[OI.x];[OI.y]</td></tr>"
		usr << browse(body,"window=injector")

	Topic(href,href_list[])
		if(href_list["oid"])
			var/o_id = text2num(href_list["oid"])
			for(var/obj/machinery/atmospherics/unary/outlet_injector/OI in world)
				if(OI.id == o_id)
					OI.on = !OI.on