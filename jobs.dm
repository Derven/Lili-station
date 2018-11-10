var/assist = 0
var/bart  = 0
var/botanist  = 0
var/sec  = 0
var/doc  = 0
var/engi  = 0

/mob
	//jobs
	var/btn = 0
	var/ast = 1
	var/sct = 0
	var/dct = 0
	var/brt = 0
	var/eng = 0

	proc/wear_on_spawn(var/mytype)
		var/obj/item/clothing/CLT = new mytype(src)
		CLT.layer = 21
		cloth = CLT
		CL.update_slot(CLT)
		CLT.wear_clothing(src)
		world << "[cloth.type];[CLT]"