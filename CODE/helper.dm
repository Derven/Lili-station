/proc/convert2energy(var/M)
	var/E = M*(SPEED_OF_LIGHT_SQ)
	return E

/proc/modulus(var/M)
	if(M >= 0)
		return M
	if(M < 0)
		return -M

/proc/cmp_numeric_dsc(a,b)
	return b - a

/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_text_asc(a,b)
	return sorttext(b,a)

/proc/cmp_text_dsc(a,b)
	return sorttext(a,b)

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_ckey_asc(client/a, client/b)
	return sorttext(b.ckey, a.ckey)

/proc/cmp_ckey_dsc(client/a, client/b)
	return sorttext(a.ckey, b.ckey)

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

//Returns the world time in english
var/timezoneOffset = 0 // The difference betwen midnight (of the host computer) and 0 world.ticks.

/proc/worldtime2text()
	return gameTimestamp("hh:mm:ss")

/proc/time_stamp(format = "hh:mm:ss")
	return time2text(world.timeofday, format)

/proc/gameTimestamp(format = "hh:mm:ss") // Get the game time in text
	return time2text(world.time - timezoneOffset + 432000 - round_start_time, format)

/* Returns 1 if it is the selected month and day */
/proc/isDay(month, day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

//returns timestamp in a sql and ISO 8601 friendly format
/proc/SQLtime(timevar)
	if(!timevar)
		timevar = world.realtime
	return time2text(timevar, "YYYY-MM-DD hh:mm:ss")


/var/midnight_rollovers = 0
/var/rollovercheck_last_timeofday = 0
/proc/update_midnight_rollover()
	if (world.timeofday < rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		return midnight_rollovers++
	return midnight_rollovers

/atom/proc/special_browse(var/mob/M, var/ibody)
	M << browse(ibody,"window=[name]")
	winset(M, name, "alpha=225")

/atom/proc/nterface(var/desc, var/hrefs)
	var/msg = {"<html>
	<head><title>Something</title><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>
	<body>
	<style>
	a{
    	text-decoration: none;
    }
    a:hover{
    	text-decoration: none;
    	color: #5B0000;
    }
    </style>"}
	var/i = 0
	for(var/d in desc)
		i++
		msg += "<b><a href='?src=\ref[src];[hrefs[i]]'>&#x203A; [d]</a></b><br>"
	msg += "</body></html>"
	return msg