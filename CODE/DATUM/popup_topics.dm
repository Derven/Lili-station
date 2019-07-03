var/datum/topiccontroller/TC = new()

/datum/topiccontroller
	Topic(href,href_list[])
		if(href_list["action"])
			var/atom/A = locate(href_list["target"])
			if(A != usr)
				call(A,href_list["action"])("")
				usr << browse(null,"window=popup")