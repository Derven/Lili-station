var/list/restartY = list()
var/list/restartN = list()
var/restarted = 0

/datum/restarter
	Topic(href,href_list[])
		if(href_list["yesorno"] == "y")
			restartN.Remove(usr.key)
			restartY.Add(usr.key)
			usr << "\red Yes, i want restart."
		if(href_list["yesorno"] == "n")
			restartY.Remove(usr.key)
			restartN.Add(usr.key)
			usr << "\blue Pls, no."

var/datum/restarter/reSTARter = new /datum/restarter()