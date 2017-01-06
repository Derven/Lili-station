/obj/item/weapon/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'power.dmi'
	icon_state = "cell"
	flags = FPRINT|TABLEPASS
	pressure_resistance = 80
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	//m_amt = 700
	//g_amt = 50
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.

/obj/item/weapon/cell/proc/give(var/amount)
	if(rigged && amount > 0)
		return 0

	if(maxcharge < amount)	return 0
	var/power_used = min(maxcharge-charge,amount)
	charge += power_used
	return power_used


/obj/item/weapon/cell/crap
	name = "Nanotrassen Brand Rechargable AA Battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	//origin_tech = "powerstorage=0"
	maxcharge = 500
	//g_amt = 40

/obj/item/weapon/cell/high
	name = "high-capacity power cell"
	//origin_tech = "powerstorage=2"
	maxcharge = 10000
	//g_amt = 60

/obj/item/weapon/cell/super
	name = "super-capacity power cell"
	//origin_tech = "powerstorage=3"
	maxcharge = 20000
	//g_amt = 70

/obj/item/weapon/cell/proc/percent()		// return % charge of cell
	return 100.0*charge/maxcharge

/obj/item/weapon/cell/hyper
	name = "hyper-capacity power cell"
	//origin_tech = "powerstorage=6"
	maxcharge = 30000
	//g_amt = 80

/obj/item/weapon/cell/infinite
	name = "infinite-capacity power cell!"
	//origin_tech =  null
	maxcharge = 30000
	//g_amt = 80

/obj/item/weapon/cell/proc/use(var/amount)
	if(rigged && amount > 0)
		return 0

	if(charge < amount)	return 0
	charge = (charge - amount)
	return 1