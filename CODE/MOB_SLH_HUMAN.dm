// /mob/simulated/living/humanoid/human vars
//---------------------
/mob/simulated/living/humanoid/human/var/icon/myhair
/mob/simulated/living/humanoid/human/var/image/mydamage
//---------------------

// /mob/simulated/living/humanoid/human procs
//---------------------
/mob/simulated/living/humanoid/human/proc/create(var/mob/new_player/player)
	mydamage = image('mob.dmi')
	key = player.key
	gender = player.gender
	create_hud(client)
	job = player.pregame_job
	name = player.pregame_name
	flavor = player.pregame_flavor
	myhair = player.pregame_hair

	if(gender == "male")
		icon_state = "mob"
		mydamage.icon_state = "damage0_mob"
	if(gender == "female")
		icon_state = "mob_f"
		mydamage.icon_state = "damage0_fem"
	overlays += mydamage

	switch(player.pregame_job)
		if("assistant")
			wear_on_spawn(/obj/item/clothing/suit/assistant, /obj/item/clothing/id/assistant)
		if("bartender")
			wear_on_spawn(/obj/item/clothing/suit/bartender, /obj/item/clothing/id/assistant)
		if("doctor")
			wear_on_spawn(/obj/item/clothing/suit/med, /obj/item/clothing/id/doctor)
		if("chef")
			wear_on_spawn(/obj/item/clothing/suit/chef, /obj/item/clothing/id/assistant)
		if("engineer")
			wear_on_spawn(/obj/item/clothing/suit/eng_suit, /obj/item/clothing/id/assistant)
		if("security")
			wear_on_spawn(/obj/item/clothing/suit/security_suit, /obj/item/clothing/id/security)
		if("botanist")
			wear_on_spawn(/obj/item/clothing/suit/hydro_suit, /obj/item/clothing/id/assistant)
		if("captain")
			wear_on_spawn(/obj/item/clothing/suit/captain, /obj/item/clothing/id/captain)
		if("clown")
			wear_on_spawn(/obj/item/clothing/suit/clown, /obj/item/clothing/id/assistant)
		if("detective")
			wear_on_spawn(/obj/item/clothing/suit/detective, /obj/item/clothing/id/security)
			var/obj/item/weapon/gun/energy/superoldrifle/revolver/DETREV = new()
			back.contents.Add(DETREV)
		if("chaplain")
			wear_on_spawn(/obj/item/clothing/suit/chaplain, /obj/item/clothing/id/assistant)

	var/obj/item/floppy/flds = new()
	back.contents.Add(flds)
	var/obj/item/device/flashlight/FLLGHT = new()
	back.contents.Add(FLLGHT)

	overlays.Add(myhair)
	if(player.pregame_body_color == "black")
		icon -= rgb(100,100,100)
	density = 1
	if(id)
		src << "Your card password is [id.password]"

/mob/simulated/living/humanoid/human/proc/update_mydamage(var/sumdam)
	overlays -= mydamage
	del(mydamage)
	mydamage = image('mob.dmi')
	mydamage.layer = 15
	if(gender == "male")
		if(sumdam < 30)
			mydamage.icon_state = "damage0_mob"
		if(sumdam >= 30 && sumdam < 60)
			mydamage.icon_state = "damage1_mob"
		if(sumdam >= 60 && sumdam < 80)
			mydamage.icon_state = "damage2_mob"
		if(sumdam >= 80)
			mydamage.icon_state = "damage3_mob"
	if(gender == "female")
		if(sumdam < 30)
			mydamage.icon_state = "damage0_fem"
		if(sumdam >= 30 && sumdam < 60)
			mydamage.icon_state = "damage1_fem"
		if(sumdam >= 60 && sumdam < 80)
			mydamage.icon_state = "damage2_fem"
		if(sumdam >= 80)
			mydamage.icon_state = "damage3_fem"
	overlays += mydamage

//NAMES GENERATE
var/global/list/m_first_names = list("John","Alexander", "Bob", "James", "Ivan", "Karl", "Victor", "Victor", "Oleg", "Stasik", "Ahmed", "Roger", "Kevin",
"Horace", "Pipen", "Roman", "Liks", "Ethan", "Sean", "Marcus", "Connor", "Mark", "Alyosha", "Kirill", "Oktay", "Yarush "," Bogdan "," Liam "," Aiden ",
"Logan", "Lucas", "Daniel", "Owen", "Henry", "Isaac", "Nathan", "Ryan", "William", "Michael", "Misha", "Jacob", "Jack","Ben"," Jaden","Randy ",
"Rusik", "Kron", "Lamer", "Lambert", "Habib", "Andersh", "Karl", "Oleg", "Karim", "Rakhim", "Maxim", "Semyon", "Christopher"," Simon","Clipper ",
"Robert", "Nolan", "Rob", "Edward", "Andy", "Charles", "Patrick", "Andresh", "Henry", "Wolfgang", "Hans", "Werner", "Walter","Christian","Sven",
"Ferinand", "August", "Adolf", "Albert", "Adler", "Bruno", "Heinrich", "German")

var/global/list/f_first_names = list("Alisa", "Tanya", "Astrid", "Melissa", "Valentine", "Sissy", "Molly", "Monna", "Christina",
"Chris", "Nora", "Rita", "Kara", "Karen", "Sandy", "Akko", "Ziv", "Diana", "Naomi", "Arina", "Ava", "Olivia","Emma","Chloe","Grace","Sofia","Miya",
"Hanna", "Adolfina", "Lola", "Abby", "Barbara", "Esther", "Fionna", "Holly", "Carrie", "Jeanne", "Charlie")

var/global/list/last_names1 = list("Craben", "Solo", "Petr", "Bob", "Log", "Cock", "Rock", "Flame", "Gram", "Ivan", "Thunder", "Lom", "Pop", "Gray", "Red", "Jack",
"Krok", "Bub", "Babakh", "Ein", "Like", "Stain", "Stein", "West", "Stone", "Black", "Chain", "Torch", "Sex ","Cold","Ray","Willer","Filat","Lamb","Stas",
"Bucks", "Strat", "Trap", "Burger", "Meme", "Git", "Dam", "Smith", "Cooper", "King", "Hall", "Green", "Crime ","Bjorn")

var/global/list/last_names2 = list("bang", "er", "erston", "ovich", "erbun", "burg", "lurk", "vater", "ter", "ov", "bert", "tone", "Stone", "Ler","Ker",
"fight", "wallpaper", "ski", "ur", "s")

/proc/rand_name(mob/C)
	if(C.gender == "male" || C.gender == "neuter")
		if(prob(60)) return "[pick(m_first_names)] [pick(last_names1)][pick(last_names2)]"
		else return "[pick(m_first_names)] [pick(last_names1)]"
	if(C.gender == "female")
		if(prob(60)) return "[pick(f_first_names)] [pick(last_names1)][pick(last_names2)]"
		else return "[pick(f_first_names)] [pick(last_names1)]"