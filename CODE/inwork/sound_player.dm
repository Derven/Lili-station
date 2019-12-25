/datum/soundplayer
	var/list/soundfiles = list('sounds/SpaceSong.ogg', 'sounds/Darkness.ogg', 'sounds/DontLeave.ogg', \
	'sounds/Redline.ogg', 'sounds/PPK.ogg', 'sounds/SpaceSen.ogg', 'sounds/Pulsar.ogg',)
	var/sound/cursound = 0
	var/ichannel = 13
	var/stop = 1
	var/mob/IAM

	proc/soundprocess()
		if(stop == 0)
			var/list/sound/soundfiles2 = list()
			for(var/sound1 in soundfiles)
				var/sound/sound2 = sound(sound1, 0, 1, ichannel, 10)
				soundfiles2.Add(sound2)
			soundfiles2.Swap(pick(1,2,3), pick(4,5,6))
			soundfiles2.Swap(pick(4,2,5), pick(1,5,3,7))
			for(var/sound/S in soundfiles2)
				IAM << S