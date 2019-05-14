/obj/machinery/logic_elements
	icon = 'logical.dmi'
	var/current_state = 0 //0 or 1

	proc/calculate()

	proc/connect()
		var/turf/levo = get_step(src, turn(dir, 90))
		var/turf/pravo = get_step(src, turn(dir, -90))

		var/turf/pered = get_step(src, dir)

		var/count = 0
		var/list/nums = list(0,0)

		for(var/obj/machinery/logic_elements/LE in levo)
			count += 1
			nums[1] = LE.current_state

		for(var/obj/machinery/logic_elements/LE in pravo)
			count += 1
			nums[2] = LE.current_state

		if(count == 2)
			current_state = calculate(nums[1], nums[2])

		for(var/obj/machinery/logic_elements/LE in pered)
			return LE

		return 0

	proc/start()
		var/obj/machinery/logic_elements/LE = connect()
		if(LE)
			world << current_state
			LE.start()

	attack_hand()
		start()

/obj/machinery/logic_elements/negative
	icon_state = "no"

	calculate(var/n)
		return !n

	connect()
		var/turf/pered = get_step(src, dir)

		for(var/obj/machinery/logic_elements/LE in pered)
			current_state = calculate(LE.current_state)
			return LE

		return 0

/obj/machinery/logic_elements/multiply
	icon_state = "logic_multiply"

	calculate(var/a, var/b)
		return a && b

/obj/machinery/logic_elements/addition
	icon_state = "logic_add"

	calculate(var/a, var/b)
		return a || b

/obj/machinery/logic_elements/equal
	icon_state = "logic_equal"

	calculate(var/a, var/b)
		return a == b