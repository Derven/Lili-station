/mob
	var/obj/lobby/lobby
	var/lobby_text
	var/sound/lobbysound = sound('sound/soviet_hymn.it')


	proc/create_lobby(var/client/C)
		C.screen += lobby

/mob/New()
	..()
	Move(pick(landmarks))

/mob/proc/show_lobby()
	lobby_text = " \
	<html> \
	<head><title>[usr.select_lang("Приемный пункт","Start game")]</title></head> \
	<body style=\"font-family: Georgia, sans-serif;\"> \
	<a href='?src=\ref[src];display=show'>[usr.select_lang("Разрешение","Screen resolution")]</a>\
	<br> \
	<br> \
	<a href='?src=\ref[src];gender=male'>Male</a>\
	<br> \
	<a href='?src=\ref[src];gender=female'>Female</a>\
	<br> \
	<br> \
	<a href='?src=\ref[src];hair=new'>Hair</a>\
	<br> \
	<br> \
	<br> \
	<a href='?src=\ref[src];lang=eng'>ENG</a>\
	<br> \
	<a href='?src=\ref[src];lang=rus'>RUS</a>\
	<br> \
	<br> \
	<a href='?src=\ref[src];enter=yes'>[usr.select_lang("Вход","Join")]</a>\
	<br> \
	<a href='?src=\ref[src];enter=nahoy'>[usr.select_lang("Выход","Exit")]</a> \
	</body></html>"
	usr << browse(lobby_text,"window=setup")

/mob/Login()
	..()
	brat << "<h1>Приветствую вас на тестовом запуске изометрической станции. Здесь вы можете ознакомитьс&#255; с текущими особенност&#255;ми и возможност&#255;ми данного проекта</h1>"
	brat << "<h1><b>Врем&#255; мен&#255;ть станцию. И спасибо за внимание.</b></h2>"
	brat << "<h2><a href=\"https://discord.gg/2VyzxfE\">Багрепорты слать сюда. Здесь можно присоединитьс&#255; к обсуждению.</h2>"
	brat << "<h2><a href=\"https://sites.google.com/view/space-station-13-isometric\">Первый сайт проекта</h2>"
	brat << "<h2><a href=\"https://plinhost.github.io/Aurora_the_cruiser\">Второй сайт проекта</h2>"
	brat << "<h2><a href=\"https://github.com/Derven/Aurora_the_cruiser\">Репозиторий</h2>"
	lobby = new(usr)
	create_hud(usr.client)
	create_lobby(usr.client)
	usr << lobbysound
	show_lobby()