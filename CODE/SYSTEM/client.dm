mob/proc/camera_refresh()
	if(dir == NORTH)
		client.eye = locate(x, y + 3, z)
	if(dir == SOUTH)
		client.eye = locate(x, y - 3, z)
	if(dir == WEST)
		client.eye = locate(x - 3, y, z)
	if(dir == EAST)
		client.eye = locate(x + 3, y, z)

/* Demonstrates using a Discord Webhook to forward chat messages from your game to a Discord text channel.

	Discord's Intro to Webhooks:
		https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks

	Discord's dev docs for webhooks:
		https://discordapp.com/developers/docs/resources/webhook

	* Discord rate-limits webhooks, so messages will fail to send if used too frequently.
		This can be worked around; you can modify HttpPost to get the response which includes
		rate limit info when it occurs. But I won't be doing that here.

		Rate limits doc:
			https://discordapp.com/developers/docs/topics/rate-limits
*/

client
	// I made key_info literally just to grab your member icon URL from the hub.
	var key_info/key_info
	show_popup_menus = 0
	verb
		// Basic chat command, but with an added webhook.
		say_to_discord(text as message)
			set category = "OOC"
			world << "<b>[src]</b>: [html_encode(text)]"
			var/F = file("discord.txt")
			// Send the message to the Discord webhook.
			HttpPost(
				/* Replace this with the webhook URL that you can Copy in Discord's Edit Webhook panel.
					It's best to use a global const for this and keep it secret so others can't use it.
				*/
				"[file2text(F)]",

				/*
				[content] is required and can't be blank.
					It's the message posted by the webhook.

				[avatar_url] and [username] are optional.
					They're taken from your key.
					They override the webhook's name and avatar for the post.
				*/
				list(
					content = text,
					username = key
				)
			)

	proc/what_do_you_want()
		var/whatwant = ""
		whatwant = input("What do you want to see in release?",
		"Release",whatwant)
		var/F = file("discord.txt")

		// Send the message to the Discord webhook.
		if(whatwant != "" || whatwant != " ")
			HttpPost(
				/* Replace this with the webhook URL that you can Copy in Discord's Edit Webhook panel.
					It's best to use a global const for this and keep it secret so others can't use it.
				*/
				"[file2text(F)]",

				/*
				[content] is required and can't be blank.
				It's the message posted by the webhook.
				[avatar_url] and [username] are optional.
				They're taken from your key.
				They override the webhook's name and avatar for the post.
				*/
				list(
					content = whatwant,
					username = key
				)
			)


client
	script="<style>\
	body { \
		font-family: 'Courier'; \
	} \
	IMG.icon {width: 64px; height: 64px; float: left;};\
	\
	.gray{color: darkgray;}\
	}</style>"
	var/run_intent = 4
	var/speeding = 0
	var/other_effects = 0
	var/gravity = 0

	proc/switch_rintent()
		if(run_intent == 4)
			run_intent = 2
			return
		if(run_intent == 2)
			run_intent = 4
			return

	Del()
		spawn(35)
			HttpPost(
				/* Replace this with the webhook URL that you can Copy in Discord's Edit Webhook panel.
					It's best to use a global const for this and keep it secret so others can't use it.
				*/
				"https://discordapp.com/api/webhooks/582821653415854081/QOoagBD-EZXd2VNagDu56bn2uBV1-U-l5W1IaCU0pWth1OPtHF-9Fd9mLSpn4SOLI-XX",

				/*
				[content] is required and can't be blank.
					It's the message posted by the webhook.

				[avatar_url] and [username] are optional.
					They're taken from your key.
					They override the webhook's name and avatar for the post.
				*/
				list(
					content = "[key] disconnected!",
					username = key
				)
			)
		return ..()

	Move()
		if(istype(mob.loc, /turf))
			if(speeding <= 0)
				speeding = 1
				var/jp = 0
				..()
				var/area/A = mob.loc.loc
				gravity = A.gravitypower
				if((istype(mob.loc, /turf/space)) || (A.has_gravity == 0))
					mob.Process_Spacemove(0)
				var/mob/simulated/living/humanoid/M = mob
				for(var/obj/item/weapon/storage/box/backpack/jetpack/J in M)
					J.jpixel()
					jp = 2
				if(istype(M, /mob/simulated/living/humanoid))
					if(M && M.stamina < 30)
						if(prob(rand(1,3)))
							M << "\red You need to catch your breath!"
						if(prob(2))
							if(M.heart)
								M.heart.activate_stimulators(/datum/heart_stimulators/light_sedative)
					var/hungryeffect = 0
					if(M && M.nutrition < 150)
						hungryeffect = 1
					if(M.heart)
						sleep(run_intent - round(M.heart.pumppower/100) - jp + hungryeffect + other_effects + gravity)
						if(run_intent < 4 && jp == 0)
							if(M && M.stamina > 1)
								M.stamina -= 1
								M.STAMINABAR.staminapixels()
								if(prob(5))
									M.nutrition -= 1

				else
					sleep(1) //placeholder
				speeding = 0

	New()
		if(src.ckey in admins)
			src.verbs += admin_verbs
		//key_info = new(key)
		return ..()

	Topic(href,list/href_list,hsrc)
		if(hsrc == src)
			if(href_list["admin"])
				if(usr.client != src)
					return
				var/mob/target
				if(href_list["target"])
					target = locate(href_list["target"])
				switch(href_list["admin"])
					if("pm")
						if(!(src.ckey in admins) && !(target.ckey in admins))
							return
						src.pm(target, input("Enter message:", "Private Message") as text)
					if("kick")
						if(!(src.ckey in admins))
							return
						src.kick(target)
					if("ban")
						if(!(src.ckey in admins))
							return
						src.ban(target)
		else ..()