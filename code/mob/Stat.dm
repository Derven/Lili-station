//mob/var/atom/cur_object_i_give
mob/var/atom/cur_object_i_see

mob/Stat()
	for(var/M in visible_containers)
		if(cur_object_i_see)
			if(M == cur_object_i_see.type)
				if(!istype(cur_object_i_see, /mob) && cur_object_i_see && cur_object_i_see.contents.len > 0) statpanel("contents", cur_object_i_see.contents)
				sleep(rand(3,5))
	//if(!istype(cur_object_i_give, /mob) && cur_object_i_give && cur_object_i_give.contents.len > 0) statpanel("container", cur_object_i_give.contents)