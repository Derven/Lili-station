var/list/bans = list()

proc/goodbay()

	//Baystation
	bans.Add("mloc")
	bans.Add("xales")
	bans.Add("sabira")
	bans.Add("kalirgue")
	bans.Add("spookerton")
	bans.Add("ecklesfire")
	bans.Add("mordeth221")
	bans.Add("hephasto")
	bans.Add("f-tangsteve")
	bans.Add("earthcrusher")
	bans.Add("melioa")
	bans.Add("technetium")
	bans.Add("textor45")
	bans.Add("miraviel")
	bans.Add("crockers")
	bans.Add("zachary09")
	bans.Add("sergeantadam")
	bans.Add("emgee")
	bans.Add("psiomegadelta")
	bans.Add("chinsky")
	bans.Add("afterthought")
	bans.Add("sir.thatoneguy")
	bans.Add("noblecaos")
	bans.Add("gentlefood")
	bans.Add("eonoc")
	//Baystation

world/IsBanned(key)
	. = ..()
	if(.)
		return
	if(ckey(key) in bans || ckey(key) == "higoten")
		. = list()
		.["Login"] = 0
		.["message"] = "You are not welcome here"