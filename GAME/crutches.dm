/atom/proc/message_to(var/rang, var/msg)
	for(var/mob/M in range(rang, src))
		M << msg

/atom/proc/update_icon()

var/image/HIDE_LEVEL_image

client/proc/MYZL()
	spawn(4)
		for(var/obj/O in range(6, mob))
			if(O.ZLevel > mob.ZLevel)
				HIDE_LEVEL_image = image(null)
				HIDE_LEVEL_image.override = 1
				HIDE_LEVEL_image.loc = O
				src << HIDE_LEVEL_image

client/proc/clear_MYZL()
	spawn(1)
		for(HIDE_LEVEL_image in images)
			images.Remove(HIDE_LEVEL_image)