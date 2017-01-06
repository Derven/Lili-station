/obj/machinery/control
	anchored = 1

/obj/machinery/control/move_button
	icon = 'panel.dmi'
	icon_state = "button"

	attack_hand()
		brat << "<b>Сквозь странный писк и жужжание вы слышите \"Запуск всех систем корабл&#255;\". Что-то начинает стучать, после чего раздаетс&#255; страшный рев двигателей</b>"
		for(var/turf/space/SPICE in world)
			SPICE.icon_state = "in_move"
		for(var/obj/glass/G in world)
			G.update_turf()

/obj/machinery/control/stop_kran
	icon = 'panel.dmi'
	icon_state = "button"

	attack_hand()
		brat << "<b>После нажати&#255; странной кнопки \"Стопкран\" корабль резко останавливаетс&#255;</b>"
		for(var/turf/space/SPICE in world)
			SPICE.icon_state = ""
		for(var/obj/glass/G in world)
			G.update_turf()