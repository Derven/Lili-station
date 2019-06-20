/obj/machinery/reactor
	icon = 'reactor.dmi'
	anchored = 1
	density = 1

	proc/openwindow()

	control
		icon_state = "reactorcontrol"
		var/list/obj/machinery/reactor/watertank/watertanks = list()
		var/list/obj/machinery/reactor/watercapacitor/watercapacitors = list()
		var/list/obj/machinery/reactor/steamgenerator/steamgenerators = list()
		var/id = 0

		New()
			..()
			spawn(rand(1,3))
				initme()


		attack_hand()
			var/info = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"

			info += "<h1>Reactor ¹[id] control computer</h1><hr>"
			for(var/obj/machinery/reactor/watertank/WT in watertanks)
				info += "<a class=\"pure-button pure-button-primary\" href='?src=\ref[WT];openwind=1;'>Watertank [WT.x];[WT.y]</a><br><br>"

			for(var/obj/machinery/reactor/watercapacitor/WC in watercapacitors)
				info += "<a class=\"pure-button pure-button-primary\" href='?src=\ref[WC];openwind=1;'>Steam capacitor [WC.x];[WC.y]</a><br><br>"

			for(var/obj/machinery/reactor/steamgenerator/SG in steamgenerators)
				info += "<a class=\"pure-button pure-button-primary\" href='?src=\ref[SG];openwind=1;'>Steam generator [SG.x];[SG.y]</a><br><br>"

			info += "</tbody></table></html></body>"
			usr << browse(info,"window=reactorcontrol")

		proc/initme()
			for(var/obj/machinery/reactor/watertank/WT in world)
				if(WT.id == id)
					watertanks += WT
			for(var/obj/machinery/reactor/watercapacitor/WC in world)
				if(WC.id == id)
					watercapacitors  += WC
			for(var/obj/machinery/reactor/steamgenerator/SG in world)
				if(SG.id == id)
					steamgenerators += SG

	watertank
		var/obj/machinery/reactor/steamgenerator/STGT
		icon_state = "watertank"
		var
			on = 0
			pumppower = 0
			id = 0
			maxpump = 300

		New()
			..()
			check_generator()

		openwindow()
			usr << browse(null,"window=watertankcontrol")
			var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
			body += "<body>Watertank control panel:<hr><table class=\"pure-table\"><thead><tr><th>#Num</th><th>Options</th></tr></thead><tbody>"
			body += "<tr><td>1#</td><td>state <a href='?src=\ref[src];state=1;'>[on == 1 ? "on" : "off"]</a></td></tr>"
			body += "<tr><td>1#</td><td>pumppower <a href='?src=\ref[src];pumpower=1;'>[pumppower]</a></td></tr>"
			body += "</tbody></table></html></body>"
			usr << browse(body,"window=watertankcontrol")

		Topic(href,href_list[])
			if(href_list["state"] == "1")
				usr << "\red You turn [on == 0 ? "on" : "off"] watertank pump"
				on = !on
				openwindow()

			if(href_list["pumpower"] == "1")
				setup_power()
				openwindow()


			if(href_list["openwind"] == "1")
				openwindow()

		proc/setup_power()
			pumppower = input("Please set watertank pump power (0/300).",
			"Your power",pumppower)
			if(pumppower > maxpump)
				pumppower = maxpump
			if(pumppower < 0)
				pumppower = 0

		proc/check_generator()
			for(var/obj/machinery/reactor/steamgenerator/SG in world)
				if(SG.id == id && STGT == null)
					STGT = SG

		process() //pumping
			if(on)
				pumppower += rand(-2,2)
				if(STGT == null)
					check_generator()
				else
					if(pumppower > 0 && STGT.cur_value < STGT.max_value)
						STGT.cur_value += pumppower

	watercapacitor
		icon_state = "capacitor"
		var
			cur_value = 0
			max_value = 250
			id = 0

		openwindow()
			usr << browse(null,"window=watercapacitor")
			var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
			body += "<body>Steam capacitor panel:<hr><table class=\"pure-table\"><thead><tr><th>#Num</th><th>Options</th></tr></thead><tbody>"
			body += "<tr><td>1#</td><td>current value [cur_value]</td></tr>"
			body += "<tr><td>2#</td><td>maximum value [max_value]</td></tr>"
			body += "</tbody></table></html></body>"
			usr << browse(body,"window=watercapacitor")

		Topic(href,href_list[])

			if(href_list["openwind"] == "1")
				openwindow()

	steamgenerator
		icon_state = "steamgenerator_cover"
		var
			cur_value = 0
			max_value = 550
			pressure = 0
			water_temp = 0
			pump_max_pressure = 30
			pump_power = 5
			on = 0
			id = 0
			reaction_stage = 1


		openwindow()
			usr << browse(null,"window=watertankcontrol")
			var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
			body += "<body>Reactor control:<hr><table class=\"pure-table\"><thead><tr><th>#Num</th><th>Options</th></tr></thead><tbody>"
			body += "<tr><td>1#</td><td>state <a href='?src=\ref[src];state=1;'>[on == 1 ? "on" : "off"]</a></td></tr>"
			body += "<tr><td>2#</td><td>pump power(This thing lowers pressure) <a href='?src=\ref[src];pumpower=1;'>[pump_power]</a></td></tr>"
			body += "<tr><td>3#</td><td>current water temperature [water_temp * 3]</td></tr>"
			body += "<tr><td>4#</td><td>current pressure [pressure]</td></tr>"
			body += "<tr><td>5#</td><td>max pressure 40000 </td></tr>"
			body += "<tr><td>6#</td><td>reactore overload pressure 35000</td></tr>"
			body += "<tr><td>7#</td><td><a href='?src=\ref[src];openwind=1;'>refresh</a></td></tr>"
			body += "</tbody></table></html></body>"
			usr << browse(body,"window=watertankcontrol")

		Topic(href,href_list[])
			if(href_list["state"] == "1")
				usr << "\red You turn [on == 0 ? "on" : "off"] reactor"
				on = !on
				openwindow()

			if(href_list["pumpower"] == "1")
				setup_power()
				openwindow()

			if(href_list["openwind"] == "1")
				openwindow()

		proc/setup_power()
			pump_power = input("Please set steam generator pump power (0/30).",
			"Your power",pump_power)
			if(pump_power > pump_max_pressure)
				pump_power = pump_max_pressure
			if(pump_power < 0)
				pump_power = 0

		proc/vaporization()
			if(cur_value > pump_max_pressure && water_temp > 200)
				cur_value -= pump_power

		proc/reaction()
			if(on == 1 || reaction_stage > 2)
				var/old_pressure = pressure
				if(cur_value > pump_max_pressure)
					water_temp += rand(12, 15) * reaction_stage
				pressure = round((water_temp * cur_value) / 25)
				if(reaction_stage == 1 || reaction_stage == 2)
					if(pressure < old_pressure)
						if(water_temp > 150)
							water_temp -= round(abs(old_pressure - pressure)/3)
							if(water_temp < 150)
								water_temp = 150
				if(reaction_stage == 1 || reaction_stage == 2)
					if(pressure < 15000)
						reaction_stage = 1
					if(pressure > 15000)
						reaction_stage = 2
					if(pressure > 35000)
						reaction_stage = 3
						world << "\red <h1> Reactor ¹[id] overloaded </h1>"
				if(pressure > 40000)
					boom(round(pressure / 1000) - 10, loc)
					del(src)

		proc/check_capacitor()
			for(var/obj/machinery/reactor/watercapacitor/R in world)
				if(R.id == id)
					if(R.cur_value < cur_value && R.cur_value < R.max_value)
						cur_value -= pump_power
						R.cur_value += pump_power
						if(cur_value < 0)
							cur_value = 0
					if(R.cur_value > cur_value && cur_value < max_value)
						cur_value += pump_power
						R.cur_value -= pump_power
						if(R.cur_value < 0)
							R.cur_value = 0

		process()
			if(on == 1)
				reaction()
				vaporization()
				check_capacitor()

	powergenerator
		var/power_rate = 0
		var/id = 0
		icon_state = "generator"
		var/obj/machinery/reactor/steamgenerator/ISTGT

		New()
			..()
			for(var/obj/machinery/reactor/steamgenerator/STGT in world)
				if(STGT.id == id)
					ISTGT = STGT

		process()
			spawn(5)
				power_rate += ISTGT.pressure
				for(var/obj/machinery/simple_apc/SA in range(7, src))
					if(power_rate > 0)
						SA.my_smes.charge += power_rate / 20
