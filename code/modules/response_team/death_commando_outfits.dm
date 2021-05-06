/datum/outfit/job/centcom/response_team/death_commando
	name = "DS Trooper"
	rt_assignment = "Death Commando"
	rt_job = "Death Commando"
	rt_mob_job = "DS Trooper"
	allow_backbag_choice = FALSE
	allow_loadout = FALSE
	pda = /obj/item/pda/centcom/death_commando
	id = /obj/item/card/id/death_commando
	l_ear = /obj/item/radio/headset/ert/alt
	box = /obj/item/storage/box/responseteam
	uniform = /obj/item/clothing/under/color/black/binary
	shoes = /obj/item/clothing/shoes/magboots/advance
	gloves = /obj/item/clothing/gloves/combat
	suit = /obj/item/clothing/suit/space/hardsuit/deathsquad
	belt = /obj/item/storage/belt/military/assault
	suit_store = /obj/item/tank/internals/emergency_oxygen/double
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	l_pocket = /obj/item/reagent_containers/hypospray/combat/nanites
	r_pocket = /obj/item/shield/energy

	l_hand = /obj/item/gun/energy/pulse

	backpack_contents = list(
		/obj/item/storage/box/flashbangs = 1,
		/obj/item/storage/box/breaching = 1,
		/obj/item/pinpointer = 1,
		/obj/item/gun/projectile/revolver/mateba = 1,
		/obj/item/ammo_box/a357 = 2,
		/obj/item/grenade/bsa_beacon = 1
	)

	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus,
		/obj/item/organ/internal/cyberimp/eyes/hud/security,
		/obj/item/organ/internal/cyberimp/brain/anti_stun/hardened,
		/obj/item/organ/internal/cyberimp/arm/combat,
		/obj/item/organ/internal/cyberimp/chest/reviver/hardened,
		/obj/item/organ/internal/cyberimp/brain/anti_drop
	)

	implants = list(
		/obj/item/implant/mindshield
	)


/datum/outfit/job/centcom/death_commando/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.mind.assigned_role = SPECIAL_ROLE_DEATHSQUAD
	H.mind.special_role = SPECIAL_ROLE_DEATHSQUAD

/datum/outfit/job/centcom/response_team/death_commando/commander
	name = "DS Commander"
	rt_assignment = "Deathsquad Officer"
	rt_job = "Deathsquad Officer"
	rt_mob_job = "Deathsquad Officer"
	uniform = /obj/item/clothing/under/rank/centcom_officer/binary
	r_hand = /obj/item/disk/nuclear/unrestricted

/datum/outfit/job/centcom/death_commando/commander/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.rename_character(null, "[pick("Lieutenant", "Captain", "Major")] [pick(GLOB.last_names)]")
	H.age = rand(35,45)
