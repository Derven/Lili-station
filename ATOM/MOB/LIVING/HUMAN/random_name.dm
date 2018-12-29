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