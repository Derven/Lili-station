/obj/machinery/power/pizd_gen
	name = "Pizdul Generator"
	desc = "A portable generator for emergency backup power"
	icon = 'power.dmi'
	icon_state = "portgen0"
	density = 1
	anchored = 1
	directwired = 1
	use_power = 0

	var
		active = 1
		power_gen = 150000
		open = 0
		recent_fault = 0
		power_output = 2

	attack_hand(mob/user as mob)
		usr << "\red Генератор производит некоторое количество энергии"
		if(active && anchored)
			add_avail(power_gen * power_output)