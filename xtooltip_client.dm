/**************************
This stuff is important
**************************/

client
	var/datum/tooltipHolder/tooltipHolder

	New()
		..()
		src.initSizeHelpers()
		src.tooltipHolder = new /datum/tooltipHolder(src)
		src.tooltipHolder.clearOld() //Clears tooltips stuck from a previous connection

		//admins
		//if(src.ckey in admins)
		//	src.verbs += admin_verbs
		//return ..()

	//I use a hidden browser element overlaying the map to get map size/positional data from JS without hitting the server
	proc/initSizeHelpers()
		src << browse(file2text("assets/html/mapSizeHelper.html"), "window=mapwindow.mapSizeHelper;titlebar=0;can_close=0;can_resize=0;can_scroll=0;border=0")

	proc/updateSizeHelpers()
		src << output("", "mapwindow.mapSizeHelper:sizeHelper.update")

	verb/windowResizeEvent()
		set hidden = 1
		set name = "window-resize-event"

		src.resizeTooltipEvent()
		src.updateSizeHelpers()
