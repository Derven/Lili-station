/obj/machinery/consol
	anchored = 1
	icon_state = "consol"
	power_channel = ENVIRON
	idle_power_usage = 200

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