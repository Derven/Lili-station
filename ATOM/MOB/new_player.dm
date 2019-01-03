/mob/new_player
	var/pregame_name
	icon_state = ""
	var/icon/pregame_human
	var/icon/pregame_hair
	var/icon/suit
	var/hair_name = "bald"
	var/pregame_flavor
	var/pregame_job = "assistant"
	var/pregame_hair_color = "black"
	see_invisible = 101
	var/pregame_body_color = "white"
	var/obj/lobby/lobby
	gender = "male"
	var/lobby_text
	var/sound/lobbysound = sound('title1.ogg')

	proc/create_lobby(var/client/C)
		if(C)
			C.screen += lobby

	proc/show_lobby()
		usr << browse(null,"window=setup")
		switch(hair_name)
			if("afro")
				pregame_hair = new('mob.dmi',icon_state = "hair_1")
			if("bald")
				pregame_hair = new('mob.dmi',icon_state = "hair_2")
			if("helipad")
				pregame_hair = new('mob.dmi',icon_state = "hair_3")
			if("short")
				pregame_hair = new('mob.dmi',icon_state = "hair_4")
			if("long")
				pregame_hair = new('mob.dmi',icon_state = "hair_5")
			if("mohawk")
				pregame_hair = new('mob.dmi',icon_state = "hair_6")

		switch(pregame_hair_color)
			if("black")
				pregame_hair += rgb(0,0,0)
			if("yellow")
				pregame_hair += rgb(150,150,0)
			if("orange")
				pregame_hair += rgb(250,150,0)
			if("blue")
				pregame_hair += rgb(0,0,255)
			if("green")
				pregame_hair += rgb(0,255,0)
			if("red")
				pregame_hair += rgb(255,0,0)

		if(gender == "male")
			pregame_human = new('mob.dmi',icon_state = "mob")
		if(gender == "female")
			pregame_human = new('mob.dmi',icon_state = "mob_f")

		switch(pregame_body_color)
			if("black")
				pregame_human -= rgb(100,100,100)

		switch(pregame_job)
			if("assistant")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "assistant_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "assistant_suit_onfem")
			if("botanist")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "hydro_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "hydro_suit_onfem")
			if("bartender")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "bartender_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "bartender_suit_onfem")
			if("security")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "security_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "security_suit_onfem")
			if("engineer")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "eng_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "eng_suit_onfem")
			if("doctor")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "med_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "med_suit_onfem")
			if("captain")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "captain_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "captain_suit_onfem")

		pregame_human.Blend(suit, ICON_OVERLAY)
		pregame_human.Blend(pregame_hair, ICON_OVERLAY)

		lobby_text = {"
		<html>
			<head>
			<title> lobby </title>
			</head>
			<body>
				<div class=lobby style=\"{font-size: 24px;}"> \
					<div class=character style=\"{margin: 1px, 15px, 15px, 1px; float: left; padding: 32px; color: #FFDE40; background-color: whitesmoke; width: 64px; height: 64px; border: 4px double #CE24CB;}\"><img src="preview"></div> \
					name: <a href='?src=\ref[src];myname=1'>[pregame_name]</a></br>
					gender: <a href='?src=\ref[src];gender=1'>male</a>/<a href='?src=\ref[src];gender=0'>female</a> </br>
                    haircut:<a href='?src=\ref[src];hair=1'>[hair_name]</a> </br>
                    <a href='?src=\ref[src];hcolor=1'>hair color</a> </br>
                    <a href='?src=\ref[src];bcolor=1'>body color</a> </br></br>
                    <a href='?src=\ref[src];flavor=1'>flavor</a>:</br>
                    <textarea rows="10" readonly="readonly" cols="45" name="flavor">[pregame_flavor ? fix1103(pregame_flavor) : ""]</textarea></br></br>
                    job:
                    <hr>
						<span class='gray' style=\"{color: darkgray};\"><a href='?src=\ref[src];job=1'>Assistant</a></span>
						<span class='green' style=\"{color: darkgreen};\"><a href='?src=\ref[src];job=2'>Botanist</a></span>
						<a href='?src=\ref[src];job=3'>Bartender</a>
						<span class='sec' style=\"{color: darkred};\"><a href='?src=\ref[src];job=4'>Security</a></span></br>
						<span class='eng' style=\"{color: orange};\"><a href='?src=\ref[src];job=5'>Engineer</a></span>
						<span class='doc' style=\"{color: darkblue};\"><a href='?src=\ref[src];job=6'>Doctor</a></span>
						<span class='cap' style=\"{color: blue};\"><a href='?src=\ref[src];job=7'>Captain</a></span>
					<hr>
					<a href='?src=\ref[src];preview=1'>view</a> / <a href='?src=\ref[src];join=1'>join</a> / <a href='?src=\ref[src];observe=1'>observe</a>
				</div>
			</body>
		</html>"}
		usr << browse_rsc(pregame_human,"preview")
		usr << browse(lobby_text,"window=setup;size=450x650;can_resize=0;can_close=0")


	Topic(href,href_list[])
		//from inputs
		if(href_list["gender"] == "1")
			gender = "male"
		if(href_list["gender"] == "0")
			gender = "female"
		if(gender == "neuter")
			gender = "male"
		if(href_list["hair"] == "1")
			hair_name = input("Select a hair style for your character.",
                      "Your hair",
                      hair_name) in list("bald","afro","mohawk", "helipad", "short", "long")

		switch(href_list["job"])
			if("1")
				pregame_job = "assistant"
			if("2")
				pregame_job = "botanist"
			if("3")
				pregame_job = "bartender"
			if("4")
				pregame_job = "security"
			if("5")
				pregame_job = "engineer"
			if("6")
				pregame_job = "doctor"
			if("7")
				pregame_job = "captain"

		if(href_list["hcolor"] == "1")
			pregame_hair_color = input("Select a hair color for your character.",
			"Your color",pregame_hair_color) in list("black","yellow","orange", "red", "green", "blue")

		if(href_list["bcolor"] == "1")
			pregame_body_color = input("Select a body color for your character.",
			"Your color",pregame_body_color) in list("black","white")

		if(href_list["myname"] == "1")
			pregame_name = input("Choose a name for your character.",
			"Your Name",pregame_name)

		if(href_list["flavor"] == "1")
			pregame_flavor = input("Write flavor for your character.",
			"Your flavor",pregame_flavor)

		if(href_list["preview"] == "1")
			show_lobby()

		if(href_list["join"] == "1")
			usr << browse(null,"window=setup")
			usr << sound(null)
			var/mob/simulated/living/humanoid/human/H = new(src.loc)
			H.create(src)
			for(var/obj/jobmark/J in world)
				if(J.job == H.job)
					H.Move(J.loc)
			del(src)

		if(href_list["observe"] == "1")
			usr << browse(null,"window=setup")
			usr << sound(null)
			var/mob/ghost/G = new(src.loc)
			G.icon = pregame_human
			G.name = pregame_name
			for(var/obj/jobmark/J in world)
				if(J.job == pregame_job)
					G.Move(J.loc)
			G.key = key
			del(src)

/mob/new_player/Login()
	..()
	density = 0
	usr << "<h1><b>Wellcome to unique isometric station based on SS13 and named 'Lili station'.</b></h2>"
	lobby = new(usr)
	create_lobby(usr.client)
	pregame_human = new('mob.dmi',icon_state = "mob")
	suit = new('suit.dmi', icon_state = "assistant_suit_onmob")
	usr << lobbysound
	pregame_name = rand_name(src)
	show_lobby()
