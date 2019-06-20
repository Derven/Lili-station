
pl_control/var
	PLASMA_DMG = 3
	PLASMA_DMG_NAME = "Plasma Damage Amount"
	PLASMA_DMG_DESC = "Self Descriptive"

	CLOTH_CONTAMINATION = 0
	CLOTH_CONTAMINATION_NAME = "Cloth Contamination"
	CLOTH_CONTAMINATION_DESC = "If this is on, plasma does damage by getting into cloth."

	PLASMAGUARD_ONLY = 0
	PLASMAGUARD_ONLY_NAME = "\"PlasmaGuard Only\""
	PLASMAGUARD_ONLY_DESC = "If this is on, only biosuits and spacesuits protect against contamination and ill effects."

	GENETIC_CORRUPTION = 0
	GENETIC_CORRUPTION_NAME = "Genetic Corruption Chance"
	GENETIC_CORRUPTION_DESC = "Chance of genetic corruption as well as toxic damage, X in 10,000."

	SKIN_BURNS = 1
	SKIN_BURNS_DESC = "Plasma has an effect similar to mustard gas on the un-suited."
	SKIN_BURNS_NAME = "Skin Burns"

	EYE_BURNS = 1
	EYE_BURNS_NAME = "Eye Burns"
	EYE_BURNS_DESC = "Plasma burns the eyes of anyone not wearing eye protection."

	CONTAMINATION_LOSS = 0.01
	CONTAMINATION_LOSS_NAME = "Contamination Loss"
	CONTAMINATION_LOSS_DESC = "How much toxin damage is dealt from contaminated clothing" //Per tick?  ASK ARYN

	PLASMA_HALLUCINATION = 0
	PLASMA_HALLUCINATION_NAME = "Plasma Hallucination"
	PLASMA_HALLUCINATION_DESC = "Does being in plasma cause you to hallucinate?"

	N2O_HALLUCINATION = 1
	N2O_HALLUCINATION_NAME = "N2O Hallucination"
	N2O_HALLUCINATION_DESC = "Does being in sleeping gas cause you to hallucinate?"


obj/var/contaminated = 0

obj/item/proc
	can_contaminate()
		//Clothing and backpacks can be contaminated.
		if(flags & PLASMAGUARD) return 0
		if(flags & SUITSPACE) return 0
		else if(istype(src,/obj/item/clothing)) return 1

	contaminate()
		//Do a contamination overlay? Temporary measure to keep contamination less deadly than it was.
		if(!contaminated)
			contaminated = 1

	decontaminate()
		contaminated = 0

/mob/proc/contaminate()

/mob/proc/pl_effects()

/mob/pl_effects()
	//Handles all the bad things plasma can do.

	//Contamination
	if(vsc.plc.CLOTH_CONTAMINATION) contaminate()

	//Anything else requires them to not be dead.
	if(stat >= 2)
		return



turf/Entered(obj/item/I)
	. = ..()
	//Items that are in plasma, but not on a mob, can still be contaminated.
	if(istype(I) && vsc.plc.CLOTH_CONTAMINATION)
		var/datum/gas_mixture/env = return_air(1)
		if(env.toxins > MOLES_PLASMA_VISIBLE + 1)
			if(I.can_contaminate())
				I.contaminate()