mob/var/atom/cur_object_i_give
//mob/var/atom/cur_object_i_give

mob/Stat()
	//if(!istype(cur_object_i_see, /mob) && cur_object_i_see && cur_object_i_see.contents.len > 0) statpanel("contents", cur_object_i_see.contents)
	if(!istype(cur_object_i_give, /mob) && cur_object_i_give && cur_object_i_give.contents.len > 0) statpanel("container", cur_object_i_give.contents)