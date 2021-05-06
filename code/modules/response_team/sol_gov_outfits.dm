/datum/outfit/job/centcom/response_team/sol_gov
	name = "Sol Gov Marine"
	rt_assignment = "Solar Federation Soldier"
	rt_job = "Solar Federation Marine"
	rt_mob_job = "Solar Federation Marine"

	uniform = /obj/item/clothing/under/solgov
	suit = /obj/item/clothing/suit/armor/bulletproof
	back = /obj/item/storage/backpack/security
	belt = /obj/item/storage/belt/military/assault
	head = /obj/item/clothing/head/soft/solgov
	glasses = /obj/item/clothing/glasses/hud/security/night
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/radio/headset/ert
	id = /obj/item/card/id/sol_gov
	r_pocket = /obj/item/flashlight/seclite
	pda = /obj/item/pda/heads/ert

	suit_store = /obj/item/gun/projectile/automatic/ar

	backpack_contents = list(
		/obj/item/clothing/shoes/magboots = 1,
		/obj/item/ammo_box/magazine/m556 = 3,
		/obj/item/gun/projectile/automatic/pistol/m1911 = 1,
		/obj/item/ammo_box/magazine/m45 = 2,
		/obj/item/grenade/frag = 1
	)

	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus
	)

	implants = list(
		/obj/item/implant/mindshield
	)

/datum/outfit/job/centcom/response_team/sol_gov/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.real_name = "[pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant First Class", "Master Sergeant", "Sergeant Major")] [pick(GLOB.last_names)]"

/datum/outfit/job/centcom/response_team/sol_gov/lieutenant
	name = "Sol Gov Lieutenant"
	rt_assignment = "Solar Federation Officer"
	rt_job = "Solar Federation Lieutenant"
	rt_mob_job = "Solar Federation Lieutenant"

	suit_store = /obj/item/gun/projectile/revolver/grenadelauncher
	uniform = /obj/item/clothing/under/solgov/command
	head = /obj/item/clothing/head/soft/solgov/command
	back = /obj/item/storage/backpack
	l_pocket = /obj/item/pinpointer/advpinpointer

	backpack_contents = list(
		/obj/item/melee/classic_baton/telescopic = 1,
		/obj/item/clothing/shoes/magboots = 1,
		/obj/item/door_remote/omni = 1,
		/obj/item/gun/projectile/automatic/pistol/deagle = 1,
		/obj/item/ammo_box/magazine/m50 = 4,
		/obj/item/ammo_box/a40mm = 2,
		/obj/item/storage/box/explosives = 1,
		/obj/item/storage/box/mindshield = 1
	)

/datum/outfit/job/centcom/response_team/sol_gov/engineer
	name = "Sol Gov Engineer"
	rt_job = "Solar Federation Combat Engineer"
	rt_mob_job = "Solar Federation Combat Engineer"

	suit_store = /obj/item/gun/projectile/automatic/proto
	back = /obj/item/storage/backpack/industrial
	l_pocket = /obj/item/melee/classic_baton/telescopic

	backpack_contents = list(
		/obj/item/clothing/shoes/magboots = 1,
		/obj/item/ammo_box/magazine/smgm9mm = 4,
		/obj/item/rcd/combat = 1,
		/obj/item/rcd_ammo/large = 2,
		/obj/item/stack/sheet/mineral/sandbags/fifty = 1,
		/obj/item/storage/box/breaching = 1
	)

	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus,
		/obj/item/organ/internal/eyes/cybernetic/shield,
		/obj/item/organ/internal/cyberimp/arm/toolset
	)

/datum/outfit/job/centcom/response_team/sol_gov/medic
	name = "Sol Gov Medic"
	rt_job = "Solar Federation Combat Medic"
	rt_mob_job = "Solar Federation Combat Medic"

	suit_store = /obj/item/gun/projectile/automatic/proto
	l_pocket = /obj/item/melee/classic_baton/telescopic
	l_hand = /obj/item/roller
	back = /obj/item/storage/backpack/medic
	belt = /obj/item/defibrillator/compact/loaded

	backpack_contents = list(
		/obj/item/clothing/shoes/magboots = 1,
		/obj/item/ammo_box/magazine/smgm9mm = 4,
		/obj/item/reagent_containers/hypospray/combat/nanites = 1,
		/obj/item/storage/firstaid/doctor = 1,
		/obj/item/handheld_defibrillator = 1,
		/obj/item/bodyanalyzer/advanced = 1,
		/obj/item/storage/pill_bottle/painkillers = 1
	)

	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus,
		/obj/item/organ/internal/cyberimp/eyes/hud/medical,
		/obj/item/organ/internal/cyberimp/arm/surgery/l,
		/obj/item/organ/internal/cyberimp/arm/medibeam
	)
