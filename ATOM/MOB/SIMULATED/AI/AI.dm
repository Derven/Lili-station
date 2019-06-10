#define OFF 0
#define ON_LOAD 1
#define INPROCESS 2
#define DEATH 3

/AIeye
	parent_type = /obj

/obj/machinery/AImodule
	icon = 'stationobjs.dmi'
	icon_state = "serverbox"

/obj/screenAI
	icon = 'AIscreen.dmi'
	layer = 60
	screen_loc = "SOUTH-1, WEST"

/obj/machinery/AImodule/cammodule
/obj/machinery/AImodule/interactmodule
/obj/machinery/AImodule/powermodule
/obj/machinery/AImodule/LAWmodule

/mob/simulated/AI
	icon = 'AI.dmi'
	icon_state = "off"
	var/state = OFF
	var/list/MODULESTYPES = list()
	var/list/obj/machinery/MODULES = list()
	var/textfile = ""
	var/obj/screenAI/SAI

	proc/add_cool_screen()
		if(client)
			SAI = new /obj/screenAI(src)
			SAI.maptext = {"<html><body><marquee behavior=\"alternate\" direction=\"left\">[textfile]</marquee></body></html>
		/	"}
			var/icon/I = icon(SAI.icon)
			SAI.maptext_width = I.Width()
			SAI.maptext_height = I.Height()
			client.screen += SAI
			while(derven == genius)
				spawn(rand(1,2))
				SAI.y += 4
		else
			return

	proc/remove_cool_screen()
		if(client)
			if(SAI)
				client.screen -= SAI
				del(SAI)
		else
			return

	verb/makemeAI()
		set src in range(1)
		client = usr.client
		add_cool_screen()

	New()
		..()
		load_screen()

	proc/check_module(var/obj/machinery/M)
		if(M.type in MODULESTYPES)
			MODULES.Add(M)
			return 1
		else
			return 0

	proc/check_recursive(var/list/filedir, var/pwd)
		var/list/FILELIST = list()

		if(pwd != "")
			FILELIST.Add(flist("ATOM/[pwd][filedir]"))
		else
			FILELIST.Add(flist("ATOM/[filedir]"))

		for(var/FILE in FILELIST)
			if(copytext(FILE,-1) != "/")
				textfile += file2text("ATOM/[pwd][FILE]")
			else
				if(pwd != "")
					pwd += filedir
				else
					pwd = filedir

				check_recursive(filedir, pwd)

	proc/load_screen()
		var/list/FILELIST = list()
		FILELIST.Add(flist("ATOM/"))
		for(var/FILE in FILELIST)
			if(copytext(FILE,-1) == "/")
				//FILELIST.Add(flist("[FILE]")) //why
				check_recursive(FILE, "")

	proc/loading()
		state = ON_LOAD
		load_screen()
		for(var/obj/machinery/M in range(8, src))
			check_module(M)
