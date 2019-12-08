obj/hud
	back
		layer = 16
		icon = 'screen1.dmi'
		icon_state = "back2"
		screen_loc = "SOUTH-1, WEST to SOUTH-1, EAST"

		verb/craft()
			set src in usr
			usr << browse(null,"window=[name]")
			var/list/descr = list()
			var/list/myhrefs = list()
			for(var/datum/crecipe/DD in available_recipes)
				var/datum/crecipe/R = DD
				descr.Add("[R.desc]")
				myhrefs.Add("production=[R.type]")

			special_browse(usr, nterface(descr, myhrefs))

		Topic(href,href_list[])
			if(href_list["production"])
				var/recipe = text2path(href_list["production"])
				var/datum/crecipe/R = new recipe
				R.check_recipe(usr)
				attack_hand(usr)

		New(var/mob/M)
			..()
			iam = M