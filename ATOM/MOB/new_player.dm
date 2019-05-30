var/captain_in_game = 0 //max 1
var/detective_in_game = 0 //max 1
var/bartender_in_game = 0 //max 1
var/chef_in_game = 0 //max 1
var/clown_in_game = 0 //max 2
var/botanist_in_game = 0 //max 2
var/chaplain_in_game = 0 //max 1

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
	var/degree_offset = 1
	gender = "male"
	var/lobby_text
	var/sound/lobbysound = sound('title1.ogg')

	proc/create_lobby(var/client/C)
		if(C)
			C.screen += lobby
			var/F = file("players.txt")
			F << "[client.ckey];[time2text(world.timeofday,"YYYY:MM:DD:hh:mm:ss")]"


	proc/show_lobby()
		usr << browse(null,"window=setup")
		if(gender == "male")
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
				if("very long")
					pregame_hair = new('mob.dmi',icon_state = "hair_7")
				if("stylish")
					pregame_hair = new('mob.dmi',icon_state = "hair_8")
				if("something weird")
					pregame_hair = new('mob.dmi',icon_state = "hair_9")
		else
			switch(hair_name)
				if("afro")
					pregame_hair = new('mob.dmi',icon_state = "hair_1_f")
				if("bald")
					pregame_hair = new('mob.dmi',icon_state = "hair_2_f")
				if("helipad")
					pregame_hair = new('mob.dmi',icon_state = "hair_3_f")
				if("short")
					pregame_hair = new('mob.dmi',icon_state = "hair_4_f")
				if("long")
					pregame_hair = new('mob.dmi',icon_state = "hair_5_f")
				if("mohawk")
					pregame_hair = new('mob.dmi',icon_state = "hair_6_f")
				if("very long")
					pregame_hair = new('mob.dmi',icon_state = "hair_7_f")
				if("stylish")
					pregame_hair = new('mob.dmi',icon_state = "hair_8_f")
				if("something weird")
					pregame_hair = new('mob.dmi',icon_state = "hair_9_f")

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
			if("clown")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "clown_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "clown_suit_onfem")
			if("detective")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "detective_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "detective_suit_onfem")
			if("chef")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "chef_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "chef_suit_onfem")
			if("chaplain")
				if(gender == "male")
					suit = new('suit.dmi', icon_state = "chaplain_suit_onmob")
				if(gender == "female")
					suit = new('suit.dmi', icon_state = "chaplain_suit_onfem")

		pregame_human.Blend(suit, ICON_OVERLAY)
		pregame_human.Blend(pregame_hair, ICON_OVERLAY)

		lobby_text = {"
		<html>
			<head>
			<title> lobby </title>
			<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.0/build/pure-min.css" integrity="sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w" crossorigin="anonymous">
			</head>
			<body>
				<div id="stars"></div>
			    <div id="stars2"></div>
			    <div id="stars3"></div>
				<div class=lobby style=\"{font-size: 24px;z-index: -1;content: " ";position: absolute;top: 2000px;width: 1px;height: 1px;background: transparent;}"> \
					<div class=character style=\"{margin: 1px, 15px, 15px, 1px; float: left; padding: 32px; color: #FFDE40; background-color: whitesmoke; width: 64px; height: 64px; border: 4px double #CE24CB;}\"><img src="preview"></div> \
					name: <a href='?src=\ref[src];myname=1'>[pregame_name]</a></br>
					gender: <a href='?src=\ref[src];gender=1'>male</a>/<a href='?src=\ref[src];gender=0'>female</a> </br>
                    haircut:<a href='?src=\ref[src];hair=1'>[hair_name]</a> </br>
                    <a href='?src=\ref[src];hcolor=1'>hair color</a> </br>
                    <a href='?src=\ref[src];bcolor=1'>body color</a> </br></br>
                    <a class="pure-button pure-button-primary"  href='?src=\ref[src];flavor=1'>flavor</a></br>
                    <textarea rows="10" readonly="readonly" cols="45" name="flavor">[pregame_flavor ? fix1103(pregame_flavor) : ""]</textarea></br></br>
					<table class="pure-table">
					    <thead>
					        <tr>
					            <th>Subdivision</th>
					            <th>Job</th>
					        </tr>
					    </thead>
					    <tbody>
					        <tr>
					            <td>Civil</td>
					            <td><span class='gray' style=\"{color: darkgray};\"><a href='?src=\ref[src];job=1'>Assistant</a></span></td>
					            <td><span class='green' style=\"{color: darkgreen};\"><a href='?src=\ref[src];job=2'>Botanist</a></span></td>
					            <td><a href='?src=\ref[src];job=3'>Bartender</a></td>
					        </tr>

					        <tr>
					            <td>Sec & Heads</td>
					            <td><span class='sec' style=\"{color: darkred};\"><a href='?src=\ref[src];job=4'>Security</a></span></td>
					            <td><span class='cap' style=\"{color: blue};\"><a href='?src=\ref[src];job=7'>Captain</a></span></td>
					            <td><span class='doc' style=\"{color: pink};\"><a href='?src=\ref[src];job=9'>Detective</a></span></td>
					        </tr>
					        <tr>
					            <td> Other </td>
					            <td><span class='eng' style=\"{color: orange};\"><a href='?src=\ref[src];job=5'>Engineer</a></span></td>
					            <td><span class='doc' style=\"{color: darkblue};\"><a href='?src=\ref[src];job=6'>Doctor</a></span></td>
					            <td><span class='doc' style=\"{color: pink};\"><a href='?src=\ref[src];job=8'>Clown</a></span></td>
					        </tr>
					        	<td></td>
					        	<td><span class='doc' style=\"{color: pink};\"><a href='?src=\ref[src];job=10'>Chef</a></span></td>
					        	<td><span class='doc' style=\"{color: pink};\"><a href='?src=\ref[src];job=11'>Chaplain</a></span></td>
					        <tr>
					        </tr>
					    </tbody>
					</table>
					<hr>
					<a class="pure-button pure-button-primary" href="?src=\ref[src];preview=1">view</a> <a class="pure-button pure-button-primary" href='?src=\ref[src];join=1'>join</a> <a class="pure-button pure-button-primary"  href='?src=\ref[src];observe=1'>observe</a>
				</div>
			</body>
		</html>"}
		usr << browse_rsc(pregame_human,"preview")
		usr << browse(lobby_text,"window=setup;size=450x700;can_resize=0;can_close=0")


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
                      hair_name) in list("bald","afro","mohawk", "helipad", "short", "long", "very long", "stylish", "something weird")

		switch(href_list["job"])
			if("1")
				pregame_job = "assistant"
			if("2")
				pregame_job = "botanist"
				if(botanist_in_game < 2)
					pregame_job = "botanist"
					botanist_in_game += 1
				else
					usr << "\red This job is already taken"
					pregame_job = "assistant"

			if("3")
				pregame_job = "bartender"
				if(bartender_in_game < 1)
					pregame_job = "bartender"
					bartender_in_game += 1
				else
					usr << "\red This job is already taken"
					pregame_job = "assistant"

			if("4")
				pregame_job = "security"
			if("5")
				pregame_job = "engineer"
			if("6")
				pregame_job = "doctor"

			if("7")
				if(captain_in_game < 1)
					pregame_job = "captain"
					captain_in_game += 1
				else
					usr << "\red This job is already taken"
					pregame_job = "assistant"

			if("8")
				pregame_job = "clown"
				if(clown_in_game < 2)
					pregame_job = "clown"
					clown_in_game += 1
				else
					usr << "\red This job is already taken"
					pregame_job = "assistant"
			if("9")
				pregame_job = "detective"
				if(detective_in_game < 1)
					pregame_job = "detective"
					detective_in_game += 1
				else
					usr << "\red This job is already taken"
					pregame_job = "assistant"

			if("10")
				pregame_job = "chef"
				pregame_job = "chef"
				if(chef_in_game < 1)
					pregame_job = "chef"
					chef_in_game += 1
				else
					usr << "\red This job is already taken"
					pregame_job = "assistant"

			if("11")
				pregame_job = "chaplain"
				pregame_job = "chaplain"
				if(chaplain_in_game < 1)
					pregame_job = "chaplain"
					chaplain_in_game += 1
				else
					usr << "\red This job is already taken"
					pregame_job = "assistant"

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
	usr << "<b>Wellcome to unique isometric station based on SS13 and named 'Lili station'.</b>"
	usr << "<FONT COLOR=violet>DISCORD: <a href='https://discord.gg/KqeSTaR'>HERE</a>"
	usr << "<FONT COLOR=blue>GITHUB: <a href='https://github.com/Derven/Lili-station'>HERE</a>"
	usr << "<FONT COLOR=red>To align the HUD, pull the output window to the right."
	usr << "<FONT COLOR=red>Change screen size by clicking \"screen_resolution\" on the titlebar of the game"
	usr << "<FONT COLOR=red>If you can't move press TAB and then UP"
	usr << "<FONT COLOR=blue>To change the movement pattern commands - > moveplus45degree()"
	usr << "<FONT COLOR=violet><a href='https://github.com/Derven/Lili-station/wiki'> WIKI </a>"
	usr << "<FONT COLOR=blue>Write about problems on github -> issues  (https://github.com/Derven/Lili-station)!!!"
	world << 'ping.ogg'
	world << "<FONT COLOR=#38BCFF>[ckey] connected!"
	lobby = new(usr)
	create_lobby(usr.client)
	pregame_human = new('mob.dmi',icon_state = "mob")
	suit = new('suit.dmi', icon_state = "assistant_suit_onmob")
	lobbysound = pick(sound('space_oddity.ogg'), sound('title2.ogg'))
	usr << lobbysound
	pregame_name = rand_name(src)
	show_lobby()
