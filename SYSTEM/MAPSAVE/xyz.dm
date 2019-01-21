/*
	/dmm_suite demo, version 1.0
		Released January 30th, 2011.

	Provides the verb write()
	Provides the verb save("name")

	This demo randomly generates an in-game map of size 7x7x7, and provides the
	user with a verb to save that map as a .dmm file. To use the demo, simply call
	'save_map' with a valid file name ("Test_File" is a valid name, "Test/File.dmm"
	is not valid). The .dmm file can now be found in the /demo directory. The user
	may also use the write() verb to see exactly what the library is writing
	without saving a file on their system. The user can also use the load() verb
	to load a previously saved dmm file.
	*/
/*
	Version History
		1.0
			- Released January 30th, 2011.
			- Rebranded as "dmm_suite" from old dmp_reader/writer demos.
	*/
var/saving = 0

proc/savemap()
	/*
		The save() verb saves a map with name "[map_name].dmm".
		*/
	var/map_name = "buildmap"
	var/dmm_suite/D = new()
	var/turf/south_west_deep = locate(1,1,1)
	var/turf/north_east_shallow = locate(world.maxx,world.maxy,world.maxz)
	D.save_map(south_west_deep, north_east_shallow, map_name, flags = DMM_IGNORE_PLAYERS)
	saving = 1
	usr << {"The file [map_name].dmm has been saved. It can be found in the same directly in which this library resides.\n\
 (Usually: C:\\Documents and Settings\\Your Name\\Application Data\\BYOND\\lib\\iainperegrine\\dmm_suite)"}

/*
mob/verb/write()
	/*
		The write() verb creates a text string of the map in dmm format
			and displays it in the client's browser.
		*/
	var/dmm_suite/D = new()
	var/turf/south_west_deep = locate(1,1,1)
	var/turf/north_east_shallow = locate(world.maxx,world.maxy,world.maxz)
	var/map_text = D.write_map(south_west_deep, north_east_shallow, flags = DMM_IGNORE_PLAYERS)
	usr << browse("<pre>[map_text]</pre>")

*/

proc/loadmap()
	/*
	The load() verb will ask a player for a dmm file (usually found in the demo
		directory) which it will then load, and transport the user to view it.
		*/
	//Test if dmm_map is a .dmm file.
	//var/file_name = "[dmm_map]"
	//var/file_extension = copytext(file_name,length(file_name)-2,0)
	//if(file_extension != "dmm")
	//	usr << "Supplied file must be a .dmm file."
	//	return

	var/saved_map = file("buildmap.dmm")
	//Determine where the new .dmm file will be loaded.
	var/new_maxz = world.maxz
	//Instanciate a new dmm_suite object.
	var/dmm_suite/new_reader = new()
	//Call load_map() to load the map file.
	new_reader.load_map(saved_map, new_maxz)
	//Transport the user to the new map's z level.
	//src.z = new_maxz

