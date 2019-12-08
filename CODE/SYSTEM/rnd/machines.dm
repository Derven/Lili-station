//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.


/obj/machinery/r_n_d
	name = "R&D Device"
	density = 1
	anchored = 1
	use_power = 1
	var
		busy = 0
		hacked = 0
		disabled = 0
		shocked = 0
		list/wires = list()
		hack_wire
		disable_wire
		shock_wire
		opened = 0
		obj/machinery/computer/rdconsole/linked_console