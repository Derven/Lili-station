var/ids = 0

/obj/item
	var/pdaslot = 0

/obj/item/clothing/PDA
	name = "PDA v0.0.2"
	icon = 'tools.dmi'
	icon_state = "pda"
	var/obj/item/mydevice
	var/obj/item/floppy/FL
	var/maininfo
	var/mymessages
	var/datum/UI/COMPUTER

	proc/initUI(var/list/bnames, var/list/bhrefs)
		COMPUTER = new /datum/UI()
		COMPUTER.initUI(bnames, bhrefs, src, "PDA")

	New()
		..()
		initUI(list("floopy","devices","messages"), list("updatefloppy=1","updatedevices=1","updatemessages=1"))

	proc/interface()
		COMPUTER.browseme(usr, "Wellcome to PDA user interface!")

	/*	maininfo = {"
		<html>
		<head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>
		<body>
			DEVICE: [mydevice]
			<br>
			FLOPPY SLOT: [FL ? "Full" : "Empty"]
			<hr>
			<a class=\"pure-button pure-button-primary\" href='?src=\ref[src];ejectd=1;'>eject Device</a>
			<a class=\"pure-button pure-button-primary\" href='?src=\ref[src];floppyr=1;'>read floppy</a>
			<hr>
			<a class=\"pure-button pure-button-primary\" href='?src=\ref[src];floppyeject=1;'>eject floppy</a>
			<a class=\"pure-button pure-button-primary\" href='?src=\ref[src];floppywr=1;'>rewrite floppy</a>
			<hr>
			<a class=\"pure-button pure-button-primary\" href='?src=\ref[src];messages=1;'>Messages</a>
			<a class=\"pure-button pure-button-primary\" href='?src=\ref[src];device=1;'>Use device</a>
		</body>
		</html>
		"}
		mymessages = {"
		<html>
		<head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>
		<a class=\"pure-button pure-button-primary\" href='?src=\ref[src];sendmsg=1;'>Send Messages</a>
		<br>
		<br>
		<a class=\"pure-button pure-button-primary\" href='?src=\ref[src];refresh=1;'>Refresh</a>
		<body>
		[messages]
		</body>
		</html>
		"}
	*/

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item))
			if(istype(W, /obj/item/floppy))
				if(!FL)
					FL = W
					usr:drop_item_v()
					W.Move(src)
			else
				if(W:pdaslot == 1)
					if(!mydevice)
						mydevice = W
						usr:drop_item_v()
						W.Move(src)
	attack_self()
		interface()
		usr << browse(maininfo, "window=pda")

	Topic(href,href_list[])
		if(usr.check_topic(src))

			if(href_list["updatefloppy"] == "1")
				COMPUTER.browseme(usr, "PDA FLOPPY IN/OUT SYSTEM!<br><br><a href='?src=\ref[src];floppyeject=1;'>eject floppy</a>\
				<br><a href='?src=\ref[src];floppyr=1;'>read floppy</a><br>\
				<a href='?src=\ref[src];floppywr=1;'>rewrite floppy</a><br><br>\
				FLOPPY SLOT: [FL ? "Full" : "Empty"]")

			if(href_list["updatedevices"] == "1")
				COMPUTER.browseme(usr, "PDA EXTENSIONS SYSTEM!<br><br><a href='?src=\ref[src];ejectd=1;'>eject Device</a>\
				<br><a href='?src=\ref[src];device=1;'>Use device</a><br><br>\
				DEVICE: [mydevice]")

			if(href_list["updatemessages"] == "1")
				COMPUTER.browseme(usr, "PDA MESSAGES SYSTEM!<br><br>\
				<a href='?src=\ref[src];sendmsg=1;'>Send Messages</a><br>\
				<a href='?src=\ref[src];refresh=1;'>Refresh</a><br><br>\
				[messages]")

			if(href_list["ejectd"] == "1")
				if(mydevice)
					mydevice.loc = usr.loc
					mydevice = null
			if(href_list["messages"] == "1")
				usr << browse(mymessages, "window=pdamsg")
			if(href_list["device"] == "1")
				if(mydevice)
					mydevice.attack_self(usr)
			if(href_list["sendmsg"] == "1")
				var/msg = input("Your message?",
					"Message")
				if(msg != "")
					sleep(rand(5,8))
					messages += fix1103("[usr]:[msg]<br><br>")
					interface()
					usr << browse(null, "window=pdamsg")
					usr << browse(mymessages, "window=pdamsg")
			if(href_list["refresh"] == "1")
				interface()
				usr << browse(null, "window=pdamsg")
				usr << browse(mymessages, "window=pdamsg")
			if(href_list["floppyr"] == "1")
				if(FL)
					var/myfloppy = {"
							<html>
							<head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>
							<body>
							[fix255(FL.floopyinfo)]
							</body>
							</html>
							"}
					usr << browse(myfloppy, "window=pdafloppy")

			if(href_list["floppywr"] == "1")
				if(FL)
					var/msg = input("Your message?",
						"Message")
					FL.floopyinfo = msg
					var/myfloppy = {"
							<html>
							<head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>
							<body>
							[fix255(FL.floopyinfo)]
							</body>
							</html>
							"}
					usr << browse(myfloppy, "window=pdafloppy")
			if(href_list["floppyeject"] == "1")
				if(FL)
					FL.loc = usr.loc
					FL = null


/obj/item/clothing/id
	var/datum/id/ID
	var/idtype
	icon = 'suit.dmi'
	icon_state = "id"
	var/list/myids = list()
	var/credits = 0
	var/cubits = 0
	var/password = 0

	New()
		..()
		ID = new /datum/id (src)
		ids += 1
		password = rand(1000,9990)
		credits = rand(500, 700)
		desc = "[name];[password]"

	captain
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/captain)
			var/datum/id/ID1 = myids[1]
			ID = new ID1(src)
			credits = rand(1500, 2500)
			desc = "[name];[password]"

	assistant
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/assistant)
			var/datum/id/ID1 = myids[1]
			ID = new ID1(src)
			credits = rand(300, 500)
			desc = "[name];[password]"

	doctor
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/doctor)
			var/datum/id/ID1 = myids[1]
			ID = new ID1(src)
			credits = rand(500, 850)
			desc = "[name];[password]"

	security
		New()
			..()
			ids += 1
			password = rand(1000,9990)
			myids.Add(/datum/id/security)
			var/datum/id/ID1 = myids[1]
			ID = new ID1(src)
			credits = rand(700, 1200)
			desc = "[name];[password]"

/obj/item/clothing/suit
	icon = 'suit.dmi'
	var/space_suit = 0

/obj/item/clothing/suit/soviet
	icon_state = "soviet_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/assistant
	icon_state = "assistant_suit"

/obj/item/clothing/suit/NTspace
	icon_state = "NT_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/syndispace
	icon_state = "syndi_spacesuit"
	space_suit = 1

/obj/item/clothing/suit/clown
	icon_state = "clown_suit"
	space_suit = 0

/obj/item/clothing/suit/chaplain
	icon_state = "chaplain_suit"
	space_suit = 0


/obj/item/clothing/suit/chef
	icon_state = "chef_suit"
	space_suit = 0

/obj/item/clothing/suit/detective
	icon_state = "detective_suit"
	space_suit = 0

/obj/item/clothing/suit/bartender
	icon_state = "bartender_suit"

/obj/item/clothing/suit/security_suit
	icon_state = "security_suit"

/obj/item/clothing/suit/detective_suit
	icon_state = "detective_suit"

/obj/item/clothing/suit/eng_suit
	icon_state = "eng_suit"

/obj/item/clothing/suit/med
	icon_state = "med_suit"

/obj/item/clothing/suit/hydro_suit
	icon_state = "hydro_suit"

/obj/item/clothing/suit
	icon = 'suit.dmi'

/obj/item/clothing/suit/soviet
	icon_state = "soviet_spacesuit"

/obj/item/clothing/suit/captain
	icon_state = "captain_suit"
	space_suit = 0