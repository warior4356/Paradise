// This represents a level we can carve up as we please, and hand out
// chunks of to whatever requests it
/datum/space_level/heap
	name = "Heap level #ERROR"
	var/datum/space_chunk/top
	var/level_radio_id
	linkage = UNAFFECTED

/datum/space_level/heap/New(z, name, transition_type, radio_id, traits)
	..(z, "Heap level #[z]", UNAFFECTED, traits)
	top = new(1, 1, zpos, world.maxx, world.maxy)
	flags = traits
	level_radio_id = radio_id

/datum/space_level/heap/proc/request(width, height)
	return top.can_fit_space(width, height)

// Returns a space chunk datum for some nerd to work with - tells them what's safe to write into, and such
/datum/space_level/heap/proc/allocate(width, height)
	if(!request(width, height))
		return null

	var/datum/space_chunk/C = top.get_optimal_chunk(width, height)
	if(!C)
		return null
	C.children.Cut()

	if(C.width == width && C.height == height && C.is_empty)
		C.set_occupied(TRUE)
		return C

	// Split the chunk into 4 pieces
	var/datum/space_chunk/return_chunk = new(C.x, C.y, C.zpos, width, height)
	C.children += return_chunk
	C.children += new /datum/space_chunk(C.x+width, C.y, C.zpos, C.width-width, height)
	C.children += new /datum/space_chunk(C.x, C.y+height, C.zpos, width, C.height-height)
	C.children += new /datum/space_chunk(C.x+width, C.y+height, C.zpos, C.width-width, C.height-height)

	for(var/datum/space_chunk/C2 in C.children)
		C2.parent = C
	return_chunk.set_occupied(TRUE)
	return return_chunk

/datum/space_level/heap/proc/free(datum/space_chunk/C)
	if(!istype(C))
		return
	if(C.zpos != zpos)
		return
	for(var/turf/T in block(locate(C.x, C.y, C.zpos), locate(C.x+C.width-1, C.y+C.height-1, C.zpos)))
		for(var/i = 1 to 3)
			for(var/atom/movable/M in T)
				if(istype(M, /mob/dead/observer) || istype(M, /mob/dview))
					continue
				qdel(M, TRUE)
				CHECK_TICK
		T.ChangeTurf(/turf/space)
		CHECK_TICK
	var/datum/space_chunk/last_empty_parent = C
	while(last_empty_parent.parent && last_empty_parent.parent.is_empty)
		last_empty_parent = last_empty_parent.parent
	// Prevent a self-qdel from killing this proc
	src = null
	for(var/datum/space_chunk/child in last_empty_parent.children)
		qdel(child)
	last_empty_parent.children.Cut()
	C.set_occupied(FALSE)

/datum/space_level/heap/level_get_radio_id()
	if(level_radio_id)
		return level_radio_id
	else
		return zpos