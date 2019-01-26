// Base stuff for Currency

/datum/currency/
	var/market_flux
	var/inflation
	var/value_in_supply_points = 0.50
	var/currency_symbol = "&#629;"
	var/world_confidence = 0.65

/datum/currency/dollar //what the hell, sure it won't exist for much longer but it's only agame right?
	value_in_supply_points = 1.00
	currency_symbol = "$"
	world_confidence = 0.95

/datum/currency/credit
	value_in_supply_points = 100.00
	currency_symbol = "C"
	world_confidence = 1.0

/datum/currency/cubit // BSG currency ftw lol
	value_in_supply_points = 0.50
	currency_symbol = "&#629;"
	world_confidence = 0.65

/datum/currency/Darsek
	value_in_supply_points = 0.80
	currency_symbol = "&#272"
	world_confidence = 0.85


/datum/currency/proc/conversion(var/datum/currency/A, var/datum/currency/B)
	var/base_amount = (A * (A:world_confidence * market_flux)) / A:value_in_supply_points
	var/end_amount = base_amount * B:value_in_supply_points
	return end_amount

/datum/currency/proc/fluctuatemarket()
	sleep(1600)
	market_flux = rand(0.9,1.1)

/datum/currency/proc/increase_confidence(var/datum/currency/A, var/increase)
	A:world_confidence += increase

/datum/currency/proc/decrease_confidence(var/datum/currency/A, var/decrease)
	A:world_confidence -= decrease

/datum/company
	var/name
	var/market_value
	var/primary_currency
	var/share_price
	var/current_funds
	var/share_quantity

/datum/company/Horizon_Research_Corporation
	name = "Horizon Research Corporation"
	primary_currency = /datum/currency/credit
	share_price = 20000
	current_funds = 100000
	share_quantity = 5000000

/datum/company/Horizon_Research_Corporation/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Syndicate
	name = "Syndicate"
	primary_currency = /datum/currency/credit
	share_price = 2000
	current_funds = 10000
	share_quantity = 100000

/datum/company/Syndicate/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Nanotransen
	name = "Nanotransen"
	primary_currency = /datum/currency/credit
	share_price = 5000
	current_funds = 8000
	share_quantity = 600000

/datum/company/Nanotransen/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Space_Science_Mechanical
	name = "Space Science Mechanical"
	primary_currency = /datum/currency/credit
	share_price = 1000
	current_funds = 11000
	share_quantity = 200000

/datum/company/Space_Science_Mechanical/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Cryonautics
	name = "Cryonautics"
	primary_currency = /datum/currency/credit
	share_price = 1000
	current_funds = 11000
	share_quantity = 200000

/datum/company/Cryonautics/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Fabrisystems
	name = "Fabrisystems"
	primary_currency = /datum/currency/credit
	share_price = 1000
	current_funds = 11000
	share_quantity = 200000

/datum/company/Fabrisystems/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Cohen_Sys
	name = "Cohen Sys"
	primary_currency = /datum/currency/credit
	share_price = 1000
	current_funds = 11000
	share_quantity = 200000

/datum/company/Cohen_Sys/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Calibrated_Aeronetics
	name = "Calibrated Aeronetics"
	primary_currency = /datum/currency/credit
	share_price = 1000
	current_funds = 11000
	share_quantity = 200000

/datum/company/Calibrated_Aeronetics/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Apex
	name = "Apex"
	primary_currency = /datum/currency/credit
	share_price = 1000
	current_funds = 11000
	share_quantity = 200000

/datum/company/Apex/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Megacorp
	name = "Megacorp"
	primary_currency = /datum/currency/credit
	share_price = 1000
	current_funds = 11000
	share_quantity = 200000

/datum/company/Megacorp/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)

/datum/company/Megatronics
	name = "Megatronics"
	primary_currency = /datum/currency/credit
	share_price = 1000
	current_funds = 11000
	share_quantity = 200000

/datum/company/Megatronics/New()
	share_price = rand(10000,100000)
	current_funds = rand(10000,100000)
	share_quantity = rand(100000,1000000)




