/obj/machinery/consol
	name = "computer"
	anchored = 1
	icon_state = "consol"
	power_channel = ENVIRON
	idle_power_usage = 200

	secconsol
		icon_state = "sec_consol"
		var/data

		attack_hand()
			usr << browse(data,"window=datasec")

		New()
			..()
			data =  "<html><head><title>Консоль управлени&#1103; тюрьмой</title></head><body>"

			for(var/obj/machinery/airlock/brig/briglock/BL in locate(/area/test_area))
				data += "<br><a href='?src=\ref[src];door=[BL.name]'>[BL.name]</a>"
			data += "</body></html>"

		Topic(href,href_list[])
			//if(href_list["enter"] == "yes")
			var/cur_door = href_list["door"]
			for(var/obj/machinery/airlock/brig/briglock/BL in locate(/area/test_area))
				if(BL.name == cur_door)
					BL.power_change()
					var/turf/simulated/floor/T = BL.loc
					if(!BL.powered())
						return
					else
						BL.close = !BL.close
						BL.density = BL.close
						BL.opacity = BL.close
						T.blocks_air = BL.close
						BL.icon_state = BL.close ? "close" : "open"
						T.update_air_properties()

/obj/machinery/consol/panic
	name = "panic console"

	var
		panic = 0

	attack_hand()
		if(panic == 0)
			brat << "Вы активировали режим \"Тревога\"!"
			for(var/obj/machinery/lamp/LAMP in machines)
				LAMP.icon_state = "danger"
			world << "\red <b>Говорит аварийсна&#255; система корабл&#255;, всем отсекам. Тревога, тревога!</b>"
			panic = 1
			for(var/turf/simulated/floor/F in world)
				F.icon_state = "danger"
			for(var/obj/glass/G in world)
				G.update_turf()
			return
		else
			brat << "Вы деактивировали режим \"Тревога\"!"
			for(var/obj/machinery/lamp/LAMP in machines)
				LAMP.icon_state = "lamp"
			world << "\blue <b>Говорит аварийсна&#255; система корабл&#255;, всем отсекам. Корабль переходит в стандартный режим!</b>"
			panic = 0
			for(var/turf/simulated/floor/F in world)
				F.icon_state = "floor"
			for(var/obj/glass/G in world)
				G.update_turf()
			return