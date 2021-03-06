#define RUS 111
#define ENG 222

//Flags for zone sleeping
#define ZONE_ACTIVE 1
#define ZONE_SLEEPING 0

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define SPEED_OF_LIGHT_SQ 9e+16
#define TRUE 1
#define FALSE 0

#define PI 3.1415

#define R_IDEAL_GAS_EQUATION	8.31 //kPa*L/(K*mol)
#define ONE_ATMOSPHERE		101.325	//kPa

#define CELL_VOLUME 2500	//liters in a cell
#define MOLES_CELLSTANDARD (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))	//moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC

#define O2STANDARD 0.21
#define N2STANDARD 0.79

#define MOLES_O2STANDARD MOLES_CELLSTANDARD*O2STANDARD	// O2 standard value (21%)
#define MOLES_N2STANDARD MOLES_CELLSTANDARD*N2STANDARD	// N2 standard value (79%)

#define MOLES_PLASMA_VISIBLE	0.5 //Moles in a standard cell after which plasma is visible

#define SPECIFIC_HEAT_TOXIN		200
#define SPECIFIC_HEAT_AIR		20
#define SPECIFIC_HEAT_CDO		30
#define HEAT_CAPACITY_CALCULATION(oxygen,carbon_dioxide,nitrogen,toxins) \
	(carbon_dioxide*SPECIFIC_HEAT_CDO + (oxygen+nitrogen)*SPECIFIC_HEAT_AIR + toxins*SPECIFIC_HEAT_TOXIN)

#define MINIMUM_HEAT_CAPACITY	0.0003
#define QUANTIZE(variable)		(round(variable,0.0001))
#define TRANSFER_FRACTION 5 //What fraction (1/#) of the air difference to try and transfer

#define BREATH_VOLUME 0.5	//liters in a normal breath  Increased to scale to SS13 speeds.
#define BREATH_PERCENTAGE BREATH_VOLUME/CELL_VOLUME
	//Amount of air to take a from a tile
#define HUMAN_NEEDED_OXYGEN	MOLES_CELLSTANDARD*BREATH_PERCENTAGE*0.16
	//Amount of air needed before pass out/suffocation commences

// Pressure limits.
#define HAZARD_HIGH_PRESSURE 750
#define HIGH_STEP_PRESSURE HAZARD_HIGH_PRESSURE/2
#define WARNING_HIGH_PRESSURE HAZARD_HIGH_PRESSURE*0.7
#define HAZARD_LOW_PRESSURE 20
#define WARNING_LOW_PRESSURE HAZARD_LOW_PRESSURE*2.5
#define MAX_PRESSURE_DAMAGE 20

// Doors!
#define DOOR_CRUSH_DAMAGE 10

// Factor of how fast mob nutrition decreases
#define	HUNGER_FACTOR 0.1
#define	REAGENTS_METABOLISM 0.05
#define REAGENTS_OVERDOSE 30

#define MINIMUM_AIR_RATIO_TO_SUSPEND 0.05
	//Minimum ratio of air that must move to/from a tile to suspend group processing
#define MINIMUM_AIR_TO_SUSPEND MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND
	//Minimum amount of air that has to move before a group processing can be suspended

#define MINIMUM_MOLES_DELTA_TO_MOVE MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND //Either this must be active
#define MINIMUM_TEMPERATURE_TO_MOVE	T20C+100 		  //or this (or both, obviously)

#define MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND 0.012
#define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND 4
	//Minimum temperature difference before group processing is suspended
#define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER 0.5
	//Minimum temperature difference before the gas temperatures are just set to be equal

#define derven 1
#define genius 1

#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION		T20C+10
#define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION	T20C+200

#define FLOOR_HEAT_TRANSFER_COEFFICIENT 0.08
#define WALL_HEAT_TRANSFER_COEFFICIENT 0.03
#define SPACE_HEAT_TRANSFER_COEFFICIENT 0.20 //a hack to partly simulate radiative heat
#define OPEN_HEAT_TRANSFER_COEFFICIENT 0.40
#define WINDOW_HEAT_TRANSFER_COEFFICIENT 0.10 //a hack for now
	//Must be between 0 and 1. Values closer to 1 equalize temperature faster
	//Should not exceed 0.4 else strange heat flow occur

#define FIRE_MINIMUM_TEMPERATURE_TO_SPREAD	150+T0C
#define FIRE_MINIMUM_TEMPERATURE_TO_EXIST	100+T0C
#define FIRE_SPREAD_RADIOSITY_SCALE		0.85
#define FIRE_CARBON_ENERGY_RELEASED	  500000 //Amount of heat released per mole of burnt carbon into the tile
#define FIRE_PLASMA_ENERGY_RELEASED	 3000000 //Amount of heat released per mole of burnt plasma into the tile
#define FIRE_GROWTH_RATE			25000 //For small fires

//Plasma fire properties
#define PLASMA_MINIMUM_BURN_TEMPERATURE		100+T0C
#define PLASMA_UPPER_TEMPERATURE			1370+T0C
#define PLASMA_MINIMUM_OXYGEN_NEEDED		2
#define PLASMA_MINIMUM_OXYGEN_PLASMA_RATIO	30
#define PLASMA_OXYGEN_FULLBURN				10

#define T0C 273.15					// 0degC
#define T20C 293.15					// 20degC
#define TCMB 2.7					// -270.3degC

#define TANK_LEAK_PRESSURE		(30.*ONE_ATMOSPHERE)	// Tank starts leaking
#define TANK_RUPTURE_PRESSURE	(45.*ONE_ATMOSPHERE) // Tank spills all contents into atmosphere

#define TANK_FRAGMENT_PRESSURE	(50.*ONE_ATMOSPHERE) // Boom 3x3 base explosion
#define TANK_FRAGMENT_SCALE	    (10.*ONE_ATMOSPHERE) // +1 for each SCALE kPa aboe threshold
								// was 2 atm

//This was a define, but I changed it to a variable so it can be changed in-game.(kept the all-caps definition because... code...) -Errorage
//#define MAX_EXPLOSION_RANGE		14					// Defaults to 12 (was 8) -- TLE


#define NORMPIPERATE 30					//pipe-insulation rate divisor
#define HEATPIPERATE 8					//heat-exch pipe insulation

#define FLOWFRAC 0.99				// fraction of gas transfered per process

#define SHOES_SLOWDOWN -1.0			// How much shoes slow you down by default. Negative values speed you up


//ITEM INVENTORY SLOT BITMASKS: (HUMANS ONLY!)
#define SLOT_OCLOTHING 1
#define SLOT_ICLOTHING 2
#define SLOT_GLOVES 4
#define SLOT_EYES 8
#define SLOT_EARS 16
#define SLOT_MASK 32
#define SLOT_HEAD 64
#define SLOT_FEET 128
#define SLOT_ID 256
#define SLOT_BELT 512
#define SLOT_BACK 1024
#define SLOT_POCKET 2048		//this is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_DENYPOCKET 4096	//this is to deny items with a w_class of 2 or 1 to fit in pockets.


//FLAGS BITMASK
#define TABLEPASS 2			// can pass by a table or rack

/********************************************************************************
*	WOO WOO WOO	THIS IS UNUSED	WOO WOO WOO										*
*	#define HALFMASK 4	// mask only gets 1/2 of air supply from internals		*
*	WOO WOO WOO	THIS IS UNUSED	WOO WOO WOO										*
********************************************************************************/

#define HEADSPACE 4			// head wear protects against space

#define MASKINTERNALS	8	// mask allows internals
#define SUITSPACE		8	// suit protects against space

#define USEDELAY 	16		// 1 second extra delay on use (Can be used once every 2s)
#define NODELAY 	32768	// 1 second attackby delay skipped (Can be used once every 0.2s). Most objects have a 1s attackby delay, which doesn't require a flag.
#define NOSHIELD	32		// weapon not affected by shield
#define CONDUCT		64		// conducts electricity (metal etc.)
#define FPRINT		256		// takes a fingerprint
#define ON_BORDER	512		// item has priority to check when entering or leaving

#define GLASSESCOVERSEYES	1024
#define MASKCOVERSEYES		1024		// get rid of some of the other retardation in these flags
#define HEADCOVERSEYES		1024		// feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH		2048		// on other items, these are just for mask/head
#define HEADCOVERSMOUTH		2048

#define NOSLIP		1024 		//prevents from slipping on wet floors, in space etc

#define OPENCONTAINER	4096	// is an open container for chemistry purposes

// #define ONESIZEFITSALL	8192	// can be worn by fatties (or children? ugh)

#define	NOREACT		16384 		//Reagents dont' react inside this container.

#define BLOCKHAIR	32768		// temporarily removes the user's hair icon

#define PLASMAGUARD 8192		//Does not get contaminated by plasma.

//flags for pass_flags
#define PASSTABLE	1
#define PASSGLASS	2
#define PASSGRILLE	4
#define PASSBLOB	8

//turf-only flags
#define NOJAUNT		1


//Bit flags for the flags_inv variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.
#define HIDEGLOVES		1	//APPLIES ONLY TO THE EXTERIOR SUIT!!
#define HIDESUITSTORAGE	2	//APPLIES ONLY TO THE EXTERIOR SUIT!!
#define HIDEJUMPSUIT	4	//APPLIES ONLY TO THE EXTERIOR SUIT!!
#define HIDESHOES		8	//APPLIES ONLY TO THE EXTERIOR SUIT!!
#define HIDEMASK	1	//APPLIES ONLY TO HELMETS!!
#define HIDEEARS	2	//APPLIES ONLY TO HELMETS!!
#define HIDEEYES	4	//APPLIES ONLY TO HELMETS!!

//clothing-overlay layers. They are floats so they always appear above the Mob
#define DAMAGE_LAYER		-23
#define UNIFORM_LAYER		-22
#define B_UNIFORM_LAYER		-21
#define SHOES_LAYER			-20
#define B_SHOES_LAYER		-19
#define ID_LAYER			-18
#define GLOVES_LAYER		-17
#define B_GLOVES_LAYER		-16
#define EARS_LAYER			-15
#define SUIT_LAYER			-14
#define B_SUIT_LAYER		-13
#define FACE_LAYER			-12
#define GLASSES_LAYER		-11
#define FACEMASK_LAYER		-10
#define B_FACEMASK_LAYER	-9
#define HEAD_LAYER			-8
#define B_HEAD_LAYER		-7
#define SUIT_STORE_LAYER	-6
#define BELT_LAYER			-5
#define BACK_LAYER			-4
#define CUFFED_LAYER		-3
#define SHIELD_LAYER		-2
#define INHANDS_LAYER		-1




//Cant seem to find a mob bitflags area other than the powers one

// bitflags for clothing parts
#define HEAD			1
#define UPPER_TORSO		2
#define LOWER_TORSO		4
#define LEG_LEFT		8
#define LEG_RIGHT		16
#define LEGS			24
#define FOOT_LEFT		32
#define FOOT_RIGHT		64
#define FEET			96
#define ARM_LEFT		128
#define ARM_RIGHT		256
#define ARMS			384
#define HAND_LEFT		512
#define HAND_RIGHT		1024
#define HANDS			1536
#define FULL_BODY		2047

/*
//bitflags for mutations
	// Extra powers:
#define SHADOW			(1<<10)	// shadow teleportation (create in/out portals anywhere) (25%)
#define SCREAM			(1<<11)	// supersonic screaming (25%)
#define EXPLOSIVE		(1<<12)	// exploding on-demand (15%)
#define REGENERATION	(1<<13)	// superhuman regeneration (30%)
#define REPROCESSOR		(1<<14)	// eat anything (50%)
#define SHAPESHIFTING	(1<<15)	// take on the appearance of anything (40%)
#define PHASING			(1<<16)	// ability to phase through walls (40%)
#define SHIELD			(1<<17)	// shielding from all projectile attacks (30%)
#define SHOCKWAVE		(1<<18)	// attack a nearby tile and cause a massive shockwave, knocking most people on their asses (25%)
#define ELECTRICITY		(1<<19)	// ability to shoot electric attacks (15%)


	// Nanoaugmentations:
#define SUPRSTR			(1<<20)	// super strength
#define RADAR			(1<<21)	// on-screen mob radar
#define ELECTRICHANDS	(1<<22)	// electric hands
#define ESWORDSYNTH		(1<<23)	// esword synthesizer
#define REBREATHER		(1<<24)	// removes the need to breathe
#define DERMALARMOR		(1<<25)	// 35% damage decrease
#define REFLEXES		(1<<26)	// dodge 50% of projectiles, dodge 25% of melee attacks
#define NANOREGEN		(1<<27)	// regenerative nanobots, -3 all damage types per second
*/

// String identifiers for associative list lookup

// mob/var/list/mutations

	// Generic mutations:
#define	TK				1
#define COLD_RESISTANCE	2
#define XRAY			3
#define HULK			4
#define CLUMSY			5
#define FAT				6
#define HUSK			7
#define NOCLONE			8


	// Extra powers:
#define LASER			9 	// harm intent - click anywhere to shoot lasers from eyes
#define HEAL			10 	// healing people with hands
#define SHADOW			11 	// shadow teleportation (create in/out portals anywhere) (25%)
#define SCREAM			12 	// supersonic screaming (25%)
#define EXPLOSIVE		13 	// exploding on-demand (15%)
#define REGENERATION	14 	// superhuman regeneration (30%)
#define REPROCESSOR		15 	// eat anything (50%)
#define SHAPESHIFTING	16 	// take on the appearance of anything (40%)
#define PHASING			17 	// ability to phase through walls (40%)
#define SHIELD			18 	// shielding from all projectile attacks (30%)
#define SHOCKWAVE		19 	// attack a nearby tile and cause a massive shockwave, knocking most people on their asses (25%)
#define ELECTRICITY		20 	// ability to shoot electric attacks (15%)


// mob/var/list/augmentations

	// Nanoaugmentations:
#define SUPRSTR			21 	// super strength (hulk powers)
#define RADAR			22 	// on-screen mob radar
#define ELECTRICHANDS	23 	// electric hands
#define ESWORDSYNTH		24 	// esword synthesizer
#define REBREATHER		25 	// removes the need to breathe
#define DERMALARMOR		26 	// 35% damage decrease
#define REFLEXES		27 	// dodge 50% of projectiles
#define NANOREGEN		28 	// regenerative nanobots, -3 all damage types per second

	// Other Mutations:
#define MNOBREATH		100 	// no need to breathe
#define MREMOTEVIEW			101 	// remote viewing
#define MREGENERATE			102 	// health regen
#define MINCREASERUN			103 	// no slowdown
#define MREMOTETALK		104 	// remote talking
#define MMORPH			105 	// changing appearance
#define MBLEND			106 	// nothing (seriously nothing)
#define MHALLUCINATION	107 	// hallucinations
#define MFINGERPRINTS	108 	// no fingerprints
#define MSHOCK			109 	// insulated hands
#define MSMALLSIZE		110 	// table climbing

//mob/var/stat things
#define CONSCIOUS	0
#define UNCONSCIOUS	1
#define DEAD		2

// channel numbers for power
#define EQUIP	1
#define LIGHT	2
#define ENVIRON	3
#define TOTAL	4	//for total power used only

// bitflags for machine stat variable
#define BROKEN		1
#define NOPOWER		2
#define POWEROFF	4		// tbd
#define MAINT		8			// under maintaince
#define EMPED		16		// temporary broken by EMP pulse

//bitflags for door switches.
#define OPEN	1
#define IDSCAN	2
#define BOLTS	4
#define SHOCK	8
#define SAFE	16

#define ENGINE_EJECT_Z	3

//metal, glass, rod stacks
#define MAX_STACK_AMOUNT_METAL	50
#define MAX_STACK_AMOUNT_GLASS	50
#define MAX_STACK_AMOUNT_RODS	60

#define GAS_O2 	(1 << 0)
#define GAS_N2	(1 << 1)
#define GAS_PL	(1 << 2)
#define GAS_CO2	(1 << 3)
#define GAS_N2O	(1 << 4)


#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))

//Bluh shields


//Damage things
#define CUT 		"cut"
#define BRUISE		"bruise"
#define BRUTE		"brute"
#define BURN		"fire"
#define TOX			"tox"
#define OXY			"oxy"
#define CLONE		"clone"
#define HALLOSS		"halloss"

#define STUN		"stun"
#define WEAKEN		"weaken"
#define PARALYZE	"paralize"
#define IRRADIATE	"irradiate"
#define STUTTER		"stutter"
#define SLUR 		"slur"
#define EYE_BLUR	"eye_blur"
#define DROWSY		"drowsy"

//Security levels
#define SEC_LEVEL_GREEN	0
#define SEC_LEVEL_BLUE	1
#define SEC_LEVEL_RED	2
#define SEC_LEVEL_DELTA	3

#define TRANSITIONEDGE	7 //Distance from edge to move to another z-level

#define CLOSED 0

proc/is_list(list/list)
	if(istype(list))
		return 1
	return 0

var/global/list/zones = list()


//See also controllers/globals.dm

//Creates a global initializer with a given InitValue expression, do not use
#define GLOBAL_MANAGED(X, InitValue)\
/datum/controller/global_vars/proc/InitGlobal##X(){\
    ##X = ##InitValue;\
    gvars_datum_init_order += #X;\
}
//Creates an empty global initializer, do not use
#define GLOBAL_UNMANAGED(X) /datum/controller/global_vars/proc/InitGlobal##X() { return; }

//Prevents a given global from being VV'd
#ifndef TESTING
#define GLOBAL_PROTECT(X)\
/datum/controller/global_vars/InitGlobal##X(){\
    ..();\
    gvars_datum_protected_varlist[#X] = TRUE;\
}
#else
#define GLOBAL_PROTECT(X)
#endif

//Standard BYOND global, do not use
#define GLOBAL_REAL_VAR(X) var/global/##X

//Standard typed BYOND global, do not use
#define GLOBAL_REAL(X, Typepath) var/global##Typepath/##X

//Defines a global var on the controller, do not use
#define GLOBAL_RAW(X) /datum/controller/global_vars/var/global##X

//Create an untyped global with an initializer expression
#define GLOBAL_VAR_INIT(X, InitValue) GLOBAL_RAW(/##X); GLOBAL_MANAGED(X, InitValue)

//Create a global const var, do not use
#define GLOBAL_VAR_CONST(X, InitValue) GLOBAL_RAW(/const/##X) = InitValue; GLOBAL_UNMANAGED(X)

//Create a list global with an initializer expression
#define GLOBAL_LIST_INIT(X, InitValue) GLOBAL_RAW(/list/##X); GLOBAL_MANAGED(X, InitValue)

//Create a list global that is initialized as an empty list
#define GLOBAL_LIST_EMPTY(X) GLOBAL_LIST_INIT(X, list())

//Create a typed global with an initializer expression
#define GLOBAL_DATUM_INIT(X, Typepath, InitValue) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, InitValue)

//Create an untyped null global
#define GLOBAL_VAR(X) GLOBAL_RAW(/##X); GLOBAL_UNMANAGED(X)

//Create a null global list
#define GLOBAL_LIST(X) GLOBAL_RAW(/list/##X); GLOBAL_UNMANAGED(X)

//Create an typed null global
#define GLOBAL_DATUM(X, Typepath) GLOBAL_RAW(Typepath/##X); GLOBAL_UNMANAGED(X)


#define START_PROCESSING(Processor, Datum) if (!Datum.isprocessing) {Datum.isprocessing = 1;Processor.processing += Datum}
#define STOP_PROCESSING(Processor, Datum) Datum.isprocessing = 0;Processor.processing -= Datum

#define R_IDEAL_GAS_EQUATION	8.31 //kPa*L/(K*mol)
#define ONE_ATMOSPHERE		101.325	//kPa

#define CELL_VOLUME 2500	//liters in a cell
#define MOLES_CELLSTANDARD (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))	//moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC

#define O2STANDARD 0.21
#define N2STANDARD 0.79

#define MOLES_O2STANDARD MOLES_CELLSTANDARD*O2STANDARD	// O2 standard value (21%)
#define MOLES_N2STANDARD MOLES_CELLSTANDARD*N2STANDARD	// N2 standard value (79%)

#define MOLES_PLASMA_VISIBLE	0.5 //Moles in a standard cell after which plasma is visible

#define BREATH_VOLUME 0.5	//liters in a normal breath
#define BREATH_PERCENTAGE BREATH_VOLUME/CELL_VOLUME
	//Amount of air to take a from a tile
#define HUMAN_NEEDED_OXYGEN MOLES_CELLSTANDARD*BREATH_PERCENTAGE*0.16
	//Amount of air needed before pass out/suffocation commences

// Pressure limits.
#define HAZARD_HIGH_PRESSURE 750
#define HIGH_STEP_PRESSURE HAZARD_HIGH_PRESSURE/2
#define WARNING_HIGH_PRESSURE HAZARD_HIGH_PRESSURE*0.7
#define HAZARD_LOW_PRESSURE 20
#define WARNING_LOW_PRESSURE HAZARD_LOW_PRESSURE*2.5
#define MAX_PRESSURE_DAMAGE 20

// Doors!
#define DOOR_CRUSH_DAMAGE 10

// Factor of how fast mob nutrition decreases
#define	HUNGER_FACTOR 0.1
#define	REAGENTS_METABOLISM 0.4

#define MINIMUM_AIR_RATIO_TO_SUSPEND 0.05
	//Minimum ratio of air that must move to/from a tile to suspend group processing
#define MINIMUM_AIR_TO_SUSPEND MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND
	//Minimum amount of air that has to move before a group processing can be suspended

#define MINIMUM_MOLES_DELTA_TO_MOVE MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND //Either this must be active
#define MINIMUM_TEMPERATURE_TO_MOVE	T20C+100 		  //or this (or both, obviously)

#define MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND 0.012
#define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND 4
	//Minimum temperature difference before group processing is suspended
#define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER 0.5
	//Minimum temperature difference before the gas temperatures are just set to be equal

#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION		T20C+10
#define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION	T20C+200

#define FLOOR_HEAT_TRANSFER_COEFFICIENT 0.08
#define WALL_HEAT_TRANSFER_COEFFICIENT 0.03
#define SPACE_HEAT_TRANSFER_COEFFICIENT 0.20 //a hack to partly simulate radiative heat
#define OPEN_HEAT_TRANSFER_COEFFICIENT 0.40
#define WINDOW_HEAT_TRANSFER_COEFFICIENT 0.10 //a hack for now
	//Must be between 0 and 1. Values closer to 1 equalize temperature faster
	//Should not exceed 0.4 else strange heat flow occur

#define FIRE_MINIMUM_TEMPERATURE_TO_SPREAD	150+T0C
#define FIRE_MINIMUM_TEMPERATURE_TO_EXIST	100+T0C
#define FIRE_SPREAD_RADIOSITY_SCALE		0.85
#define FIRE_CARBON_ENERGY_RELEASED	  500000 //Amount of heat released per mole of burnt carbon into the tile
#define FIRE_PLASMA_ENERGY_RELEASED	 3000000 //Amount of heat released per mole of burnt plasma into the tile
#define FIRE_GROWTH_RATE			25000 //For small fires

//Plasma fire properties
#define PLASMA_MINIMUM_BURN_TEMPERATURE		100+T0C
#define PLASMA_UPPER_TEMPERATURE			1370+T0C
#define PLASMA_MINIMUM_OXYGEN_NEEDED		2
#define PLASMA_MINIMUM_OXYGEN_PLASMA_RATIO	30
#define PLASMA_OXYGEN_FULLBURN				10

#define T0C 273.15					// 0degC
#define T20C 293.15					// 20degC
#define TCMB 2.7					// -270.3degC

#define TANK_LEAK_PRESSURE		(30.*ONE_ATMOSPHERE)	// Tank starts leaking
#define TANK_FRAGMENT_PRESSURE	(50.*ONE_ATMOSPHERE) // Boom 3x3 base explosion
#define TANK_FRAGMENT_SCALE	    (10.*ONE_ATMOSPHERE) // +1 for each SCALE kPa aboe threshold
								// was 2 atm
#define MAX_EXPLOSION_RANGE		14					// Defaults to 12 (was 8) -- TLE


#define NORMPIPERATE 30					//pipe-insulation rate divisor
#define HEATPIPERATE 8					//heat-exch pipe insulation

#define FLOWFRAC 0.99				// fraction of gas transfered per process

#define SHOES_SLOWDOWN -1.0			// How much shoes slow you down by default. Negative values speed you up


//FLAGS BITMASK
#define ONBACK 1			// can be put in back slot
#define TABLEPASS 2			// can pass by a table or rack
#define HALFMASK 4			// mask only gets 1/2 of air supply from internals

#define HEADSPACE 4			// head wear protects against space

#define MASKINTERNALS 8		// mask allows internals
#define SUITSPACE 8			// suit protects against space

#define USEDELAY 16			// 1 second extra delay on use (Can be used once every 2s)
#define NODELAY 32768		// 1 second attackby delay skipped (Can be used once every 0.2s). Most objects have a 1s attackby delay, which doesn't require a flag.
#define NOSHIELD 32			// weapon not affected by shield
#define CONDUCT 64			// conducts electricity (metal etc.)
#define ONBELT 128			// can be put in belt slot
#define FPRINT 256			// takes a fingerprint
#define ON_BORDER 512		// item has priority to check when entering or leaving

#define GLASSESCOVERSEYES 1024
#define MASKCOVERSEYES 1024		// get rid of some of the other retardation in these flags
#define HEADCOVERSEYES 1024		// feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH 2048		// on other items, these are just for mask/head
#define HEADCOVERSMOUTH 2048

#define NOSLIP 1024 //prevents from slipping on wet floors, in space etc

#define OPENCONTAINER	4096	// is an open container for chemistry purposes

#define ONESIZEFITSALL	8192	// can be worn by fatties (or children? ugh)

#define	NOREACT	16384 //Reagents dont' react inside this container.

#define BLOCKHAIR 32768			// temporarily removes the user's hair icon

//flags for pass_flags
#define PASSTABLE 1
#define PASSGLASS 2
#define PASSGRILLE 4
#define PASSBLOB 8

//turf-only flags
#define NOJAUNT 1

//Cant seem to find a mob bitflags area other than the powers one
#define NOGRAV 1


// bitflags for clothing parts
#define HEAD			1
#define UPPER_TORSO		2
#define LOWER_TORSO		4
#define LEG_LEFT		8
#define LEG_RIGHT		16
#define LEGS			24
#define FOOT_LEFT		32
#define FOOT_RIGHT		64
#define FEET			96
#define ARM_LEFT		128
#define ARM_RIGHT		256
#define ARMS			384
#define HAND_LEFT		512
#define HAND_RIGHT		1024
#define HANDS			1536
#define FULL_BODY		2047

//mob/var/stat things

// channel numbers for power
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
#define TOTAL 4	//for total power used only

// bitflags for machine stat variable
#define BROKEN 1
#define NOPOWER 2
#define POWEROFF 4		// tbd
#define MAINT 8			// under maintaince
#define EMPED 16		// temporary broken by EMP pulse

#define ENGINE_EJECT_Z 3

//metal, glass, rod stacks
#define MAX_STACK_AMOUNT_METAL 50
#define MAX_STACK_AMOUNT_GLASS 50
#define MAX_STACK_AMOUNT_RODS 60


//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
//(Exceptions: extended, sandbox and nuke) -Errorage
//Was list("1" = 10, "3" = 15, "4" = 60, "5" = 15); changed it to list("3" = 30, "4" = 70).
//Spacing should be a reliable method of getting rid of a body -- Urist.

#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))


var/list/global_mutations = list() // list of hidden mutation things

//Bluh shields


//Damage things
#define BRUTE "brute"
#define BURN "fire"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"

#define STUN "stun"
#define WEAKEN "weaken"
#define PARALYZE "paralize"
#define IRRADIATE "irradiate"
#define STUTTER "stutter"
#define EYE_BLUR "eye_blur"
#define DROWSY "drowsy"

//var/static/list/scarySounds = list('thudswoosh.ogg','Taser.ogg','armbomb.ogg','hiss1.ogg','hiss2.ogg','hiss3.ogg','hiss4.ogg','hiss5.ogg','hiss6.ogg','Glassbr1.ogg','Glassbr2.ogg','Glassbr3.ogg','Welder.ogg','Welder2.ogg','airlock.ogg','clownstep1.ogg','clownstep2.ogg')

//Security levels
#define SEC_LEVEL_GREEN 0
#define SEC_LEVEL_BLUE 1
#define SEC_LEVEL_RED 2
#define SEC_LEVEL_DELTA 3

// This is eventually for wjohn to add more color standardization stuff like I keep asking him >:(

#define COLOR_INPUT_DISABLED "#F0F0F0"
#define COLOR_INPUT_ENABLED "#D3B5B5"

//#define COLOR_WHITE            "#EEEEEE"
//#define COLOR_SILVER           "#C0C0C0"
//#define COLOR_GRAY             "#808080"
#define COLOR_FLOORTILE_GRAY   "#8D8B8B"
#define COLOR_ALMOST_BLACK	   "#333333"
//#define COLOR_BLACK            "#000000"
#define COLOR_RED              "#FF0000"
//#define COLOR_RED_LIGHT        "#FF3333"
//#define COLOR_MAROON           "#800000"
#define COLOR_YELLOW           "#FFFF00"
//#define COLOR_OLIVE            "#808000"
//#define COLOR_LIME             "#32CD32"
#define COLOR_GREEN            "#008000"
#define COLOR_CYAN             "#00FFFF"
//#define COLOR_TEAL             "#008080"
#define COLOR_BLUE             "#0000FF"
//#define COLOR_BLUE_LIGHT       "#33CCFF"
//#define COLOR_NAVY             "#000080"
#define COLOR_PINK             "#FFC0CB"
//#define COLOR_MAGENTA          "#FF00FF"
#define COLOR_PURPLE           "#800080"
#define COLOR_ORANGE           "#FF9900"
#define COLOR_BEIGE            "#CEB689"
#define COLOR_BLUE_GRAY        "#75A2BB"
#define COLOR_BROWN            "#BA9F6D"
#define COLOR_DARK_BROWN       "#997C4F"
#define COLOR_DARK_ORANGE      "#C3630C"
#define COLOR_GREEN_GRAY       "#99BB76"
#define COLOR_RED_GRAY         "#B4696A"
#define COLOR_PALE_BLUE_GRAY   "#98C5DF"
#define COLOR_PALE_GREEN_GRAY  "#B7D993"
#define COLOR_PALE_RED_GRAY    "#D59998"
#define COLOR_PALE_PURPLE_GRAY "#CBB1CA"
#define COLOR_PURPLE_GRAY      "#AE8CA8"

//Color defines used by the assembly detailer.
#define COLOR_ASSEMBLY_BLACK   "#545454"
#define COLOR_ASSEMBLY_BGRAY   "#9497AB"
#define COLOR_ASSEMBLY_WHITE   "#E2E2E2"
#define COLOR_ASSEMBLY_RED     "#CC4242"
#define COLOR_ASSEMBLY_ORANGE  "#E39751"
#define COLOR_ASSEMBLY_BEIGE   "#AF9366"
#define COLOR_ASSEMBLY_BROWN   "#97670E"
#define COLOR_ASSEMBLY_GOLD    "#AA9100"
#define COLOR_ASSEMBLY_YELLOW  "#CECA2B"
#define COLOR_ASSEMBLY_GURKHA  "#999875"
#define COLOR_ASSEMBLY_LGREEN  "#789876"
#define COLOR_ASSEMBLY_GREEN   "#44843C"
#define COLOR_ASSEMBLY_LBLUE   "#5D99BE"
#define COLOR_ASSEMBLY_BLUE    "#38559E"
#define COLOR_ASSEMBLY_PURPLE  "#6F6192"

//See also controllers/globals.dm

//Creates a global initializer with a given InitValue expression, do not use
#define GLOBAL_MANAGED(X, InitValue)\
/datum/controller/global_vars/proc/InitGlobal##X(){\
    ##X = ##InitValue;\
    gvars_datum_init_order += #X;\
}
//Creates an empty global initializer, do not use
#define GLOBAL_UNMANAGED(X) /datum/controller/global_vars/proc/InitGlobal##X() { return; }

//Prevents a given global from being VV'd
#ifndef TESTING
#define GLOBAL_PROTECT(X)\
/datum/controller/global_vars/InitGlobal##X(){\
    ..();\
    gvars_datum_protected_varlist[#X] = TRUE;\
}
#else
#define GLOBAL_PROTECT(X)
#endif

//Standard BYOND global, do not use
#define GLOBAL_REAL_VAR(X) var/global/##X

//Standard typed BYOND global, do not use
#define GLOBAL_REAL(X, Typepath) var/global##Typepath/##X

//Defines a global var on the controller, do not use
#define GLOBAL_RAW(X) /datum/controller/global_vars/var/global##X

//Create an untyped global with an initializer expression
#define GLOBAL_VAR_INIT(X, InitValue) GLOBAL_RAW(/##X); GLOBAL_MANAGED(X, InitValue)

//Create a global const var, do not use
#define GLOBAL_VAR_CONST(X, InitValue) GLOBAL_RAW(/const/##X) = InitValue; GLOBAL_UNMANAGED(X)

//Create a list global with an initializer expression
#define GLOBAL_LIST_INIT(X, InitValue) GLOBAL_RAW(/list/##X); GLOBAL_MANAGED(X, InitValue)

//Create a list global that is initialized as an empty list
#define GLOBAL_LIST_EMPTY(X) GLOBAL_LIST_INIT(X, list())

//Create a typed global with an initializer expression
#define GLOBAL_DATUM_INIT(X, Typepath, InitValue) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, InitValue)

//Create an untyped null global
#define GLOBAL_VAR(X) GLOBAL_RAW(/##X); GLOBAL_UNMANAGED(X)

//Create a null global list
#define GLOBAL_LIST(X) GLOBAL_RAW(/list/##X); GLOBAL_UNMANAGED(X)

//Create an typed null global
#define GLOBAL_DATUM(X, Typepath) GLOBAL_RAW(Typepath/##X); GLOBAL_UNMANAGED(X)

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
#define subtypesof(typepath) ( typesof(typepath) - typepath )

/proc/init_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//returns a list of paths to every subtype of prototype (excluding prototype)
//if no list/L is provided, one is created.
/proc/init_paths(prototype, list/L)
	if(!istype(L))
		L = list()
		for(var/path in subtypesof(prototype))
			L+= path
		return L

