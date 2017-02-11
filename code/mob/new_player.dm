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
	<head><title>Приемный пункт</title></head> \
	<body style=\"font-family: Georgia, sans-serif;\"> \
	<a href='?src=\ref[src];display=show'>Разрешение</a>\
	<br> \
	<br> \
	<a href='?src=\ref[src];enter=yes'>Вход</a>\
	<br> \
	<a href='?src=\ref[src];enter=nahoy'>Выход</a> \
	</body></html>"
	usr << browse(lobby_text,"window=setup")

/mob/Login()
	..()
	brat << "<h1>Здраствуйte, товариsch! Экипаж космического крейсера \"Аврора\" желает вам удачного полета</h1>"
	lobby = new(usr)
	create_hud(usr.client)
	create_lobby(usr.client)
	usr << lobbysound
	show_lobby()