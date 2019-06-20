var/ADNA
var/BDNA
var/DDNA
var/CDNA

proc/RANDOMIZEDNA()
	ADNA = pick(1, 0)
	BDNA = !ADNA
	CDNA = pick(1, 0)
	BDNA = !CDNA

proc/CHECK_DNA(var/datum/dna/DNA)
	if(DNA.mydna =="A1" && ADNA)
		return 1

	if(DNA.mydna =="A1" && !ADNA)
		return 0

	if(DNA.mydna =="A0" && !ADNA)
		return 1

	if(DNA.mydna =="A0" && ADNA)
		return 0

	if(DNA.mydna =="B1" && BDNA)
		return 1

	if(DNA.mydna =="B1" && !BDNA)
		return 0

	if(DNA.mydna =="B0" && !BDNA)
		return 1

	if(DNA.mydna =="B0" && BDNA)
		return 0

	if(DNA.mydna =="C1" && CDNA)
		return 1

	if(DNA.mydna =="C1" && !CDNA)
		return 0

	if(DNA.mydna =="C0" && !CDNA)
		return 1

	if(DNA.mydna =="C0" && CDNA)
		return 0

	if(DNA.mydna =="D1" && DDNA)
		return 1

	if(DNA.mydna =="D1" && !DDNA)
		return 0

	if(DNA.mydna =="D0" && !DDNA)
		return 1

	if(DNA.mydna =="D0" && DDNA)
		return 0

/datum/dna
	var/mydna

	New(var/directive)
		..()
		mydna = pick("A", "B", "C", "D")
		if(directive == "active")
			switch(mydna)
				if("A")
					mydna += num2text(ADNA)
				if("B")
					mydna += num2text(BDNA)
				if("C")
					mydna += num2text(CDNA)
				if("D")
					mydna += num2text(DDNA)

		if(directive == "passive")
			switch(mydna)
				if("A")
					mydna += num2text(!ADNA)
				if("B")
					mydna += num2text(!BDNA)
				if("C")
					mydna += num2text(!CDNA)
				if("D")
					mydna += num2text(!DDNA)

		if(directive == "random")
			mydna += pick("1", "0")
