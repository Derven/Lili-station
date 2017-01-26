/obj/machinery/monkeycloner
	name = "Monkey dispensor"
	icon = 'cloning.dmi'
	icon_state = "pod_0"
	density = 0
	anchored = 1

	var/cloning = 0

/obj/machinery/monkeycloner/attack_hand()
	if(!cloning)
		cloning = 5

		icon_state = "pod_g"

/obj/machinery/monkeycloner/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)
	//src.updateDialog()

	if(cloning)
		cloning -= 1
		if(!cloning)
			new /mob/monkey(src.loc)
			icon_state = "pod_0"

	return