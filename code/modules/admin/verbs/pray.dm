/mob/living/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))
	if(!msg)
		return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, "<span class='warning'>You cannot pray (muted).</span>")
			return
		if(client.handle_spam_prevention(msg, MUTE_PRAY, OOC_COOLDOWN))
			return

	var/image/cross = image('icons/obj/storage.dmi',"bible")
	var/font_color = "purple"
	var/prayer_type = "PRAYER"
	var/deity
	if(usr.job == "Chaplain")
		if(SSticker && SSticker.Bible_deity_name)
			deity = SSticker.Bible_deity_name
		cross = image('icons/obj/storage.dmi',"kingyellow")
		font_color = "blue"
		prayer_type = "CHAPLAIN PRAYER"
	else if(iscultist(usr))
		cross = image('icons/obj/storage.dmi',"tome")
		font_color = "red"
		prayer_type = "CULTIST PRAYER"
		deity = SSticker.cultdat.entity_name

	log_say("(PRAYER) [msg]", usr)
	msg = "<span class='notice'>[bicon(cross)]<b><font color=[font_color]>[prayer_type][deity ? " (to [deity])" : ""][mind && mind.isholy ? " (blessings: [mind.num_blessed])" : ""]:</font> [key_name(src, 1)] ([ADMIN_QUE(src,"?")]) ([ADMIN_PP(src,"PP")]) ([ADMIN_VV(src,"VV")]) ([ADMIN_TP(src,"TP")]) ([ADMIN_SM(src,"SM")]) ([admin_jump_link(src)]) ([ADMIN_SC(src,"SC")]) (<A HREF='?_src_=holder;Bless=[UID()]'>BLESS</A>) (<A HREF='?_src_=holder;Smite=[UID()]'>SMITE</A>):</b> [msg]</span>"

	for(var/client/X in GLOB.admins)
		if(check_rights(R_EVENT,0,X.mob))
			to_chat(X, msg)
			if(X.prefs.sound & SOUND_PRAYERNOTIFY)
				SEND_SOUND(X, sound('sound/items/PDA/ambicha4-short.ogg'))
	to_chat(usr, "Your prayers have been received by the gods.")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Pray") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/Centcomm_announce(text, mob/Sender)
	var/msg = sanitize(copytext(text, 1, MAX_MESSAGE_LEN))
	msg = "<span class='boldnotice'><font color=orange>CENTCOMM: </font>[key_name(Sender, 1)] ([ADMIN_PP(Sender,"PP")]) ([ADMIN_VV(Sender,"VV")]) ([ADMIN_TP(Sender,"TP")]) ([ADMIN_SM(Sender,"SM")]) ([admin_jump_link(Sender)]) ([ADMIN_BSA(Sender,"BSA")]) ([ADMIN_CENTCOM_REPLY(Sender,"RPLY")])):</span> [msg]"
	for(var/client/X in GLOB.admins)
		if(R_EVENT & X.holder.rights)
			to_chat(X, msg)
			if(X.prefs.sound & SOUND_ADMINHELP)
				SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))

/proc/Syndicate_announce(text, mob/Sender)
	var/msg = sanitize(copytext(text, 1, MAX_MESSAGE_LEN))
	msg = "<span class='boldnotice'><font color='#DC143C'>SYNDICATE: </font>[key_name(Sender, 1)] ([ADMIN_PP(Sender,"PP")]) ([ADMIN_VV(Sender,"VV")]) ([ADMIN_TP(Sender,"TP")]) ([ADMIN_SM(Sender,"SM")]) ([admin_jump_link(Sender)]) ([ADMIN_BSA(Sender,"BSA")]) ([ADMIN_SYNDICATE_REPLY(Sender,"RPLY")]):</span> [msg]"
	for(var/client/X in GLOB.admins)
		if(check_rights(R_EVENT,0,X.mob))
			to_chat(X, msg)
			if(X.prefs.sound & SOUND_ADMINHELP)
				SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))

/proc/HONK_announce(text, mob/Sender)
	var/msg = sanitize(copytext(text, 1, MAX_MESSAGE_LEN))
	msg = "<span class='boldnotice'><font color=pink>HONK: </font>[key_name(Sender, 1)] ([ADMIN_PP(Sender,"PP")]) ([ADMIN_VV(Sender,"VV")]) ([ADMIN_TP(Sender,"TP")]) ([ADMIN_SM(Sender,"SM")]) ([admin_jump_link(Sender)]) ([ADMIN_BSA(Sender,"BSA")]) (<A HREF='?_src_=holder;HONKReply=[Sender.UID()]'>RPLY</A>):</span> [msg]"
	for(var/client/X in GLOB.admins)
		if(R_EVENT & X.holder.rights)
			to_chat(X, msg)
			if(X.prefs.sound & SOUND_ADMINHELP)
				SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))

/proc/ERT_Announce(text, mob/Sender, repeat_warning)
	var/msg = sanitize(copytext(text, 1, MAX_MESSAGE_LEN))
	msg = "<span class='adminnotice'><b><font color=orange>ERT REQUEST: </font>[key_name(Sender, 1)] ([ADMIN_PP(Sender,"PP")]) ([ADMIN_VV(Sender,"VV")]) ([ADMIN_TP(Sender,"TP")]) ([ADMIN_SM(Sender,"SM")]) ([admin_jump_link(Sender)]) ([ADMIN_BSA(Sender,"BSA")]) (<A HREF='?_src_=holder;ErtReply=[Sender.UID()]'>RESPOND</A>):</b> [msg]</span>"
	if(repeat_warning)
		msg += "<BR><span class='adminnotice'><b>WARNING: ERT request has gone 5 minutes with no reply!</b></span>"
	for(var/client/X in GLOB.admins)
		if(check_rights(R_EVENT,0,X.mob))
			to_chat(X, msg)
			if(X.prefs.sound & SOUND_ADMINHELP)
				SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))

/proc/Nuke_request(text , mob/Sender)
	var/syndicate_nukes = get_nukes_with_codes(station_z_only = TRUE, NT_nukes = FALSE, syndicate_nukes = TRUE)
	var/nanotrasen_nukes = get_nukes_with_codes(station_z_only = TRUE, NT_nukes = TRUE, syndicate_nukes = FALSE)
	var/msg = sanitize(copytext(text, 1, MAX_MESSAGE_LEN))
	msg = "<span class='adminnotice'><b><font color=orange>NUKE CODE REQUEST: </font>[key_name(Sender)] ([ADMIN_PP(Sender,"PP")]) ([ADMIN_VV(Sender,"VV")]) ([ADMIN_TP(Sender,"TP")]) ([ADMIN_SM(Sender,"SM")]) ([admin_jump_link(Sender)]) ([ADMIN_BSA(Sender,"BSA")]) ([ADMIN_CENTCOM_REPLY(Sender,"RPLY")]):</b> [msg]</span>"
	for(var/client/X in GLOB.admins)
		if(check_rights(R_EVENT,0,X.mob))
			to_chat(X, msg)
			for(var/obj/machinery/nuclearbomb/bomb in nanotrasen_nukes)
				to_chat(X, "<span class='adminnotice'><b>Code to nanotrasen [bomb.name] in [get_area(bomb).name] is: [bomb.r_code]</b></span>")
			for(var/obj/machinery/nuclearbomb/bomb in syndicate_nukes)
				to_chat(X, "<span class='adminnotice'><b>Code to syndicate [bomb.name] in [get_area(bomb).name] is: [bomb.r_code]</b></span>")
			if(X.prefs.sound & SOUND_ADMINHELP)
				SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))
