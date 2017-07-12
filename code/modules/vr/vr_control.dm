/obj/machinery/computer/vr_control
	name = "VR console"
	desc = "A list and control panel for all virtual servers."
	icon_screen = "comm_logs"

	light_color = LIGHT_COLOR_DARKGREEN

/obj/machinery/computer/vr_control/New()
	..()

/obj/machinery/computer/vr_control/Destroy()
	return ..()

/obj/machinery/computer/vr_control/attack_ai(mob/user)
	ui_interact(user)


/obj/machinery/computer/vr_control/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/vr_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	switch(alert("What would you like to do?", "VR Control", "Join Room", "Make Room", "Cancel"))
		if("Join Room")
			var/datum/vr_room/room = input(user, "Choose a room to join.","Select Level") as null|anything in vr_rooms
			room = vr_rooms[room]
			spawn_vr_avatar(user, room)
			if(!(user.ckey))
				user.death()
		if("Make Room")
			var/name = input(user, "Name your new Room","Name here.") as null|text
			var/datum/vr_room/room = input(user, "Choose a Level to load into your new Room.","Select Level") as null|anything in vr_templates - "lobby"
			make_vr_room(name, room, 1)
		if("Cancel")
			return
