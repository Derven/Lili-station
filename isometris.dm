/*********************************************************
          _____                    _____                   _______                   _____                    _____             _____                    _____                    _____                    _____
         /\    \                  /\    \                 /::\    \                 /\    \                  /\    \           /\    \                  /\    \                  /\    \                  /\    \
        /::\    \                /::\    \               /::::\    \               /::\____\                /::\    \         /::\    \                /::\    \                /::\    \                /::\    \
        \:::\    \              /::::\    \             /::::::\    \             /::::|   |               /::::\    \        \:::\    \              /::::\    \               \:::\    \              /::::\    \
         \:::\    \            /::::::\    \           /::::::::\    \           /:::::|   |              /::::::\    \        \:::\    \            /::::::\    \               \:::\    \            /::::::\    \
          \:::\    \          /:::/\:::\    \         /:::/~~\:::\    \         /::::::|   |             /:::/\:::\    \        \:::\    \          /:::/\:::\    \               \:::\    \          /:::/\:::\    \
           \:::\    \        /:::/__\:::\    \       /:::/    \:::\    \       /:::/|::|   |            /:::/__\:::\    \        \:::\    \        /:::/__\:::\    \               \:::\    \        /:::/__\:::\    \
           /::::\    \       \:::\   \:::\    \     /:::/    / \:::\    \     /:::/ |::|   |           /::::\   \:::\    \       /::::\    \      /::::\   \:::\    \              /::::\    \       \:::\   \:::\    \
  ____    /::::::\    \    ___\:::\   \:::\    \   /:::/____/   \:::\____\   /:::/  |::|___|______    /::::::\   \:::\    \     /::::::\    \    /::::::\   \:::\    \    ____    /::::::\    \    ___\:::\   \:::\    \
 /\   \  /:::/\:::\    \  /\   \:::\   \:::\    \ |:::|    |     |:::|    | /:::/   |::::::::\    \  /:::/\:::\   \:::\    \   /:::/\:::\    \  /:::/\:::\   \:::\____\  /\   \  /:::/\:::\    \  /\   \:::\   \:::\    \
/::\   \/:::/  \:::\____\/::\   \:::\   \:::\____\|:::|____|     |:::|    |/:::/    |:::::::::\____\/:::/__\:::\   \:::\____\ /:::/  \:::\____\/:::/  \:::\   \:::|    |/::\   \/:::/  \:::\____\/::\   \:::\   \:::\____\
\:::\  /:::/    \::/    /\:::\   \:::\   \::/    / \:::\    \   /:::/    / \::/    / ~~~~~/:::/    /\:::\   \:::\   \::/    //:::/    \::/    /\::/   |::::\  /:::|____|\:::\  /:::/    \::/    /\:::\   \:::\   \::/    /
 \:::\/:::/    / \/____/  \:::\   \:::\   \/____/   \:::\    \ /:::/    /   \/____/      /:::/    /  \:::\   \:::\   \/____//:::/    / \/____/  \/____|:::::\/:::/    /  \:::\/:::/    / \/____/  \:::\   \:::\   \/____/
  \::::::/    /            \:::\   \:::\    \        \:::\    /:::/    /                /:::/    /    \:::\   \:::\    \   /:::/    /                 |:::::::::/    /    \::::::/    /            \:::\   \:::\    \
   \::::/____/              \:::\   \:::\____\        \:::\__/:::/    /                /:::/    /      \:::\   \:::\____\ /:::/    /                  |::|\::::/    /      \::::/____/              \:::\   \:::\____\
    \:::\    \               \:::\  /:::/    /         \::::::::/    /                /:::/    /        \:::\   \::/    / \::/    /                   |::| \::/____/        \:::\    \               \:::\  /:::/    /
     \:::\    \               \:::\/:::/    /           \::::::/    /                /:::/    /          \:::\   \/____/   \/____/                    |::|  ~|               \:::\    \               \:::\/:::/    /
      \:::\    \               \::::::/    /             \::::/    /                /:::/    /            \:::\    \                                  |::|   |                \:::\    \               \::::::/    /
       \:::\____\               \::::/    /               \::/____/                /:::/    /              \:::\____\                                 \::|   |                 \:::\____\               \::::/    /
        \::/    /                \::/    /                 ~~                      \::/    /                \::/    /                                  \:|   |                  \::/    /                \::/    /
         \/____/                  \/____/                                           \/____/                  \/____/                                    \|___|                   \/____/                  \/____/

*********************************************************/

world
	icon_size = 64	// 64x64 icon size by default
	view = 8// show up to 8 tiles outward from center (13x13 view)
	turf = /turf/space
	map_format = ISOMETRIC_MAP
	mob = /mob/new_player
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Isometric Space Station 13"
	status = {"<big><b>Isometric Station 13</b></big>:Metastation, respawn, grief allowed, in development(<a href=\"https://github.com/Derven/Lili-station\">Github</a>)<br>
	<img src="https://i.imgur.com/gD8AcC6.png">
	"}
	tick_lag = 0.3

var/contentlist = list(/datum/content/library, /datum/content/dream, /datum/content/dream2, /datum/content/dream3, /datum/content/dream4, /datum/content/dream5, /datum/content/whatstorymark, /datum/content/forkmypork, /datum/content/racers)
var/ingamecontent = list()
var/datum/eventmaster/arcadiy

proc/autoreboot()
	var/reboot = 0
	while(derven == genius)
		sleep(850)
		reboot = 1
		for(var/mob/M in world)
			if(M.client)
				reboot = 0
		if(reboot == 1)
			world.Reboot(1)

/world/New()
//	master_controller = new /datum/controller/game_controller()
	if(!air_master)
		air_master = new /datum/controller/air_system()
		air_master.setup()
	..()
	arcadiy = new /datum/eventmaster()
	goodbay()
	init_z_pixel()

	//global_turf_init()
	//sd_SetDarkIcon()

	start_processing()
	spawn(1)
		Master.Initialize(15, FALSE)
	Master.process()

	//spawn(-1) master_controller.setup()

	load_admins()
	game_mode_begin()
	for(var/obj/machinery/atmospherics/machine in world)
		machine.initialize()
	for(var/obj/machinery/atmospherics/machine in world)
		machine.build_network()
	autoreboot()
	return

/*
	World Topics Handler
*/

/world/Topic(T)
	var/list/input = params2list(T) //splitting strings like a=0&b=1&c=hello into list
	if ("status" in input)
		var/list/s = list()
		var/p = 0
		for(var/mob/M in world)
			if(M.client)
				p++ //counting mobs with client inside and adding it
		s["players"] = p //current players
		s["duration"] = round((world.time-round_start_time)/10) //time in seconds after roundstart
		//s["map_name"] = GLOB.map_name
		s["host"] = world.host ? world.host : null //returning host ckey if windows host. On linux returns null
		return list2params(s) //returning achieved variables
	return "try status" //if input is incorrect display this
