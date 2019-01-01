/datum/idchecker
	var/obj/machine = null
	var/list/iddata = list()
	var/stat = 1

	proc/check_id(var/obj/item/clothing/id/id)
		if(stat)
			for(var/idtype in iddata)
				for(var/idtype2 in id.myids)
					if(idtype == idtype2)
						return 1
			return 0

proc/add_idchecker(var/obj/myloc, var/ids)
	var/datum/idchecker/IDCHECK = new(myloc)
	IDCHECK.machine = myloc
	for(var/id in ids)
		IDCHECK.iddata.Add(id)
	return IDCHECK


/datum/id
	assistant
	security
	captain
	doctor