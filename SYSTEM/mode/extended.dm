/datum/game_mode/extended
	name = "extended"

/datum/game_mode/extended/announce()
	world << "<B>The current game mode is - Extended Role-Playing!</B>"
	world << "<B>Just have fun and role-play!</B>"

/datum/game_mode/extended/proc/post_setup()
	return null