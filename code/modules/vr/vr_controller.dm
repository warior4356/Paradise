//Control file with the backbone for the vr rooms and avatars

var/list/vr_rooms = list()
var/list/vr_rooms_offical = list()
var/list/vr_roman_ready = list()
var/list/vr_all_players = list()
var/roomcap = 20

/datum/vr_room
	var/name = null
	var/datum/map_template/vr/template = null
	var/datum/space_chunk/chunk = null
	var/list/spawn_points = list()
	var/list/players = list()
	var/expires = 1
	var/delete_timer = null
	var/round_timer = null

/datum/vr_room/proc/cleanup()
	space_manager.free_space(src.chunk)
	vr_rooms.Remove(src.name)
	qdel(src)

/datum/vr_room/proc/vr_round()
	if(players.len == 1)
		var/mob/living/carbon/human/virtual_reality/winner = players[1]
		to_chat(vr_all_players, "SYSTEM MESSAGE: [winner] has won the PVP match in The [name]. New match in 30 seconds.")

	for(var/mob/living/carbon/human/virtual_reality/player in players)
		player.death()

	if(name == "Roman Arena")
		template = pick("roman1")
	else
		cleanup()
		return

	template = vr_templates[template]
	space_manager.free_space(src.chunk)
	spawn_points = list()
	chunk = space_manager.allocate_space(template.width, template.height)
	template.load(locate(chunk.x,chunk.y,chunk.zpos), centered = FALSE)

	for(var/atom/landmark in chunk.search_chunk(landmarks_list))
		if(landmark.name == "avatarspawn")
			spawn_points.Add(landmark)
		if(landmark.name == "vr_loot_common" && template.loot_common.len > 0)
			if(prob(90))
				var/picked = pick(template.loot_common)
				new picked(get_turf(landmark))
		if(landmark.name == "vr_loot_rare" && template.loot_rare.len > 0)
			if(prob(50))
				var/picked = pick(template.loot_rare)
				new picked(get_turf(landmark))

	if(name == "Roman Arena")
		for(var/mob/living/carbon/human/virtual_reality/player in vr_roman_ready)
			to_chat(player, "The Roman Gladiator match starts in 30 seconds, please be in the lobby.")

		sleep(30 SECONDS)

		for(var/mob/living/carbon/human/virtual_reality/player in vr_roman_ready)
			vr_roman_ready.Remove(player)
			if(player.myroom == vr_rooms_offical["Lobby"])
				var/mob/living/carbon/human/virtual_reality/avatar = spawn_vr_avatar(player, src)
				avatar.equip_to_slot_if_possible(new /obj/item/device/observer, slot_r_ear, 1, 1, 1)
				player.death()

	if(players.len > 0)
		round_timer = addtimer(src, "vr_round", 5 MINUTES)
	else
		round_timer = addtimer(src, "vr_round", 1 MINUTES)

proc/make_vr_room(name, template, expires)
	var/datum/vr_room/R = new
	R.name = name
	R.template = template
	R.template = vr_templates[R.template]
	R.chunk = space_manager.allocate_space(R.template.width, R.template.height)
	R.expires = expires
	R.template.load(locate(R.chunk.x,R.chunk.y,R.chunk.zpos), centered = FALSE)

	if(expires == 1)
		vr_rooms[R.name] = R
		R.delete_timer = addtimer(R, "cleanup", 3 MINUTES)
	else if(expires == 0)
		vr_rooms_offical[R.name] = R
	else if (expires == 2)
		vr_rooms_offical[R.name] = R
		R.round_timer = addtimer(R, "vr_round", 1 MINUTES)

	for(var/atom/landmark in R.chunk.search_chunk(landmarks_list))
		if(landmark.name == "avatarspawn")
			R.spawn_points.Add(landmark)
		if(landmark.name == "vr_loot_common" && R.template.loot_common.len > 0)
			if(prob(90))
				var/picked = pick(R.template.loot_common)
				new picked(get_turf(landmark))
		if(landmark.name == "vr_loot_rare" && R.template.loot_rare.len > 0)
			if(prob(50))
				var/picked = pick(R.template.loot_rare)
				new picked(get_turf(landmark))


//Control code for the avatars
proc/build_virtual_avatar(mob/living/carbon/human/H, location, datum/vr_room/room)
	if(!location)
		return
	var/mob/living/carbon/human/virtual_reality/vr_avatar
	location = get_turf(location)
	vr_avatar = new /mob/living/carbon/human/virtual_reality(location)
	if(istype(H, /mob/living/carbon/human/virtual_reality))
		var/mob/living/carbon/human/virtual_reality/V = H
		vr_avatar.real_me = V.real_me
	else
		vr_avatar.real_me = H
	vr_avatar.species = new /datum/species/human()

	vr_avatar.species.name = H.species.name
	vr_avatar.species.name_plural = H.species.name_plural
	vr_avatar.species.icobase = H.species.icobase
	vr_avatar.species.deform = H.species.deform
	vr_avatar.species.butt_sprite = H.species.butt_sprite
	vr_avatar.tail = H.species.tail
	vr_avatar.dna = H.dna.Clone()
	vr_avatar.sync_organ_dna(assimilate=1)
	for(var/O in vr_avatar.bodyparts_by_name)
		var/obj/item/organ/external/old_E = H.bodyparts_by_name[O]
		var/obj/item/organ/external/new_E = vr_avatar.bodyparts_by_name[O]
    	// Maybe add handling for robolimbs later

		new_E.species = old_E.species
		new_E.sync_colour_to_human(H)
	//var/obj/item/organ/external/head/new_head = vr_avatar.get_organ("head")
	//var/obj/item/organ/external/head/old_head = H.get_organ("head")
	//new_head.copy_hair_from(old_head)
	spawn(0)
		vr_avatar.update_mutantrace(1)
		vr_avatar.regenerate_icons()
		vr_avatar.UpdateAppearance()
		domutcheck(vr_avatar, null)
		//__init_body_accessory(/datum/body_accessory/body)
		//__init_body_accessory(/datum/body_accessory/tail)
	vr_avatar.remove_language("Sol Common")
	for(var/datum/language/L in H.languages)
		vr_avatar.add_language(L.name)

	vr_avatar.name = H.name
	vr_avatar.real_name = H.real_name
	vr_avatar.undershirt = H.undershirt
	vr_avatar.underwear = H.underwear
	vr_avatar.equipOutfit(room.template.outfit)
	vr_avatar.myroom = room
	vr_all_players.Add(vr_avatar)
//	to_chat(world, "s_col = [new_head.s_col]")
	if(room.name == "Lobby")
		if(vr_avatar.a_intent != INTENT_HELP)
			vr_avatar.a_intent_change(INTENT_HELP)
		vr_avatar.can_change_intents = 0 //Now you have no choice but to be helpful.
	return vr_avatar


proc/control_remote(mob/living/carbon/human/H, mob/living/carbon/human/virtual_reality/vr_avatar)
	if(H.ckey)
		vr_avatar.ckey = H.ckey
		if(istype(H, /mob/living/carbon/human/virtual_reality))
			var/mob/living/carbon/human/virtual_reality/V = H
			vr_avatar.real_me = V.real_me
		else
			vr_avatar.real_me = H

proc/spawn_vr_avatar(mob/living/carbon/human/H, datum/vr_room/room)

	var/mob/living/carbon/human/virtual_reality/vr_human
	vr_human = build_virtual_avatar(H, pick(room.spawn_points), room)
	room.players.Add(vr_human)
	deltimer(room.delete_timer)
	control_remote(H, vr_human)
	return vr_human

//Preloaded rooms
/hook/roundstart/proc/starting_levels()
	make_vr_room("Lobby", "lobby", 0)
	make_vr_room("Roman Arena", "roman1", 2)
	return 1