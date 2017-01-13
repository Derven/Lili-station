/obj/machinery/control
	anchored = 1

/obj/machinery/control/move_button
	icon = 'panel.dmi'
	icon_state = "button"

	attack_hand()
		if(check_engine())

			brat << "<b>Сквозь странный писк и жужжание вы слышите \"Запуск всех систем корабл&#255;\". Что-то начинает стучать, после чего раздаетс&#255; страшный рев двигателей</b>"
			for(var/turf/space/SPICE in world)
				SPICE.icon_state = "in_move"
			for(var/obj/glass/G in world)
				G.update_turf()
		else
			sleep(3)
			brat << "<b>Сквозь странный писк и жужжание вы слышите \"Запуск двигателей не удаетс&#255;, часть двигателей отсутствует или неисправна</b>"
			for(var/obj/machinery/motor/SHIP in world)
				SHIP.off()

/obj/machinery/control/on_planet
	icon = 'panel.dmi'
	icon_state = "button"

	attack_hand()
		if(check_engine())
			brat << "<b>Сквозь странный писк и жужжание вы слышите \"Запуск всех систем корабл&#255;\". Что-то начинает стучать, после чего раздаетс&#255; страшный рев двигателей. Вас переносит на космодром и вы успешно приземл&#255;етесь</b>"
			move_to_planet(z)

/proc/check_engine()
	var/counter = 0
	for(var/obj/machinery/motor/SHIP in world)
		counter += 1

	for(var/obj/machinery/motor/SHIP in world)
		if(counter > 7)
			SHIP.on()
			return 1
		else
			SHIP.off()
			return 0

proc/off_engine()
	for(var/obj/machinery/motor/SHIP in world)
		SHIP.off()

/obj/machinery/control/stop_kran
	icon = 'panel.dmi'
	icon_state = "button"

	attack_hand()
		brat << "<b>После нажати&#255; странной кнопки \"Стопкран\" корабль резко останавливаетс&#255;</b>"
		for(var/turf/space/SPICE in world)
			SPICE.icon_state = ""
		for(var/obj/glass/G in world)
			G.update_turf()
		for(var/obj/machinery/motor/SHIP in world)
			SHIP.off()

proc/move_to_planet(var/z_level)
	for(var/turf/space/S in world)
		if(z_level == S.z || z_level - 1 == S.z)
			S = new /turf/unsimulated/floor/planet(S)

	for(var/turf/unsimulated/floor/station_base/ST in world)
		ST.invisibility = 0

		if(istype(ST, /turf/unsimulated/floor/station_base/wall))
			ST.density = 1


proc/move_to_space(var/z_level)
	for(var/turf/unsimulated/floor/planet/S in world)
		if(z_level == S.z || z_level - 1 == S.z)
			S = new /turf/space(S)

	for(var/turf/unsimulated/floor/station_base/ST in world)
		ST.invisibility = 0