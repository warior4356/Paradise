/datum/map_template/vr
	name = null
	var/id = null // For blacklisting purposes, all vr levels need an id
	var/description = "This is a placeholder. Please contact your virtual adminsitrator if you see this."
	var/outfit = null
	var/death_type = VR_DROP_ALL
	var/drop_whitelist = null
	var/drop_blacklist = null
	var/loot_common = null
	var/loot_rare = null
	var/prefix = null
	var/suffix = null

/datum/map_template/vr/New()
	if(!name && id)
		name = id

	mappath = prefix + suffix
	..(path = mappath)