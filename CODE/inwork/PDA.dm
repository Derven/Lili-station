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