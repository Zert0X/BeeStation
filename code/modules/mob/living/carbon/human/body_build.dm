var/global/datum/body_build/default_body_build = new
GLOBAL_LIST_EMPTY(bb_clothing_icon_states)

/hook/global_init/proc/makeDatumRefLists()
	var/paths = typesof(/datum/body_build)
	for(var/T in paths)
		var/datum/body_build/BB = new T
		GLOB.bb_clothing_icon_states[BB.type] = list()
		//GLOB.bb_clothing_icon_states[BB.type][slot_hidden_str]     = icon_states(BB.clothing_icons["slot_hidden"])
		GLOB.bb_clothing_icon_states[BB.type][slot_w_uniform_str]  = icon_states(BB.clothing_icons["slot_w_uniform"])
		GLOB.bb_clothing_icon_states[BB.type][slot_wear_suit_str]  = icon_states(BB.clothing_icons["slot_suit"])
		GLOB.bb_clothing_icon_states[BB.type][slot_gloves_str]     = icon_states(BB.clothing_icons["slot_gloves"])
		GLOB.bb_clothing_icon_states[BB.type][slot_glasses_str]    = icon_states(BB.clothing_icons["slot_glasses"])
		GLOB.bb_clothing_icon_states[BB.type][slot_l_ear_str]      = icon_states(BB.clothing_icons["slot_l_ear"])
		//GLOB.bb_clothing_icon_states[BB.type][slot_r_ear_str]      = icon_states(BB.clothing_icons["slot_r_ear"])
		GLOB.bb_clothing_icon_states[BB.type][slot_wear_mask_str]  = icon_states(BB.clothing_icons["slot_wear_mask"])
		GLOB.bb_clothing_icon_states[BB.type][slot_head_str]       = icon_states(BB.clothing_icons["slot_head"])
		GLOB.bb_clothing_icon_states[BB.type][slot_shoes_str]      = icon_states(BB.clothing_icons["slot_shoes"])
		GLOB.bb_clothing_icon_states[BB.type][slot_belt_str]       = icon_states(BB.clothing_icons["slot_belt"])
		GLOB.bb_clothing_icon_states[BB.type][slot_s_store_str]    = icon_states(BB.clothing_icons["slot_s_store"])
		GLOB.bb_clothing_icon_states[BB.type][slot_back_str]       = icon_states(BB.clothing_icons["slot_back"])
		GLOB.bb_clothing_icon_states[BB.type][slot_tie_str]        = icon_states(BB.clothing_icons["slot_tie"])
		GLOB.bb_clothing_icon_states[BB.type][slot_l_hand_str]     = icon_states(BB.clothing_icons["slot_l_hand"])
		GLOB.bb_clothing_icon_states[BB.type][slot_r_hand_str]     = icon_states(BB.clothing_icons["slot_r_hand"])
		//GLOB.bb_clothing_icon_states[BB.type][slot_wear_id_str]    = icon_states(BB.clothing_icons["slot_wear_id"])
		GLOB.bb_clothing_icon_states[BB.type][slot_handcuffed_str] = icon_states(BB.misk_icon)
		GLOB.bb_clothing_icon_states[BB.type][slot_legcuffed_str]  = icon_states(BB.misk_icon)

/datum/body_build
	var/name         = "Default"

	var/genders      = list(MALE, FEMALE)
	var/index        = ""
	var/roboindex    = ""										// for slim and slim_alt BBs prothesis
	var/misk_icon    = 'icons/mob/mob.dmi'
	var/list/clothing_icons = list(
		"slot_w_uniform" = 'icons/inv_slots/uniforms/mob.dmi',
		"slot_suit"      = 'icons/inv_slots/suits/mob.dmi',
		"slot_gloves"	 = 'icons/inv_slots/gloves/mob.dmi',
		"slot_glasses"   = 'icons/inv_slots/glasses/mob.dmi',
		"slot_l_ear"     = 'icons/inv_slots/ears/mob.dmi',
		"slot_wear_mask" = 'icons/inv_slots/masks/mob.dmi',
		"slot_head"      = 'icons/inv_slots/hats/mob.dmi',
		"slot_shoes"     = 'icons/inv_slots/shoes/mob.dmi',
		"slot_belt"      = 'icons/inv_slots/belts/mob.dmi',
		"slot_s_store"   = 'icons/inv_slots/belts/belt_mirror.dmi',
		"slot_back"      = 'icons/inv_slots/back/mob.dmi',
		"slot_tie"       = 'icons/inv_slots/neck/mob.dmi',
		//"slot_hidden"    = 'icons/inv_slots/hidden/mob.dmi',
		//"slot_wear_id"   = 'icons/mob/onmob/id.dmi',
		"slot_l_hand"    = 'icons/mob/inhands/items_lefthand.dmi',
		"slot_r_hand"    = 'icons/mob/inhands/items_righthand.dmi'
		)

	//var/rig_back     = 'icons/inv_slots/rig/mob.dmi'
	//var/blood_icon   = 'icons/mob/human_races/masks/blood_human.dmi'
	//var/dam_mask     = 'icons/mob/human_races/masks/dam_mask_human.dmi'

/datum/body_build/proc/get_mob_icon(slot, icon_state)
	var/icon/I
	if(!(slot in default_onmob_slots))
		log_world("##ERROR. Wrong sprite group for mob icon \"[slot]\"")
		return I // Nonexistent slot, just give 'em an empty icon
	for(var/datum/body_build/BB in list(src, default_body_build))
		switch(slot)
			if(slot_handcuffed_str || slot == slot_legcuffed_str)
				I = BB.misk_icon
			else
				I = BB.clothing_icons[slot]
		if(icon_state in GLOB.bb_clothing_icon_states[BB.type][slot])
			break
	return I

/datum/body_build/slim
	name                 = "Slim"

	index                = "_slim"
	roboindex            = "_slim"
	genders              = list(FEMALE)
	clothing_icons       = list(
		"slot_w_uniform" = 'icons/inv_slots/uniforms/mob_slim.dmi',
		"slot_suit"      = 'icons/inv_slots/suits/mob_slim.dmi',
		"slot_gloves"    = 'icons/inv_slots/gloves/mob_slim.dmi',
		"slot_glasses"   = 'icons/inv_slots/glasses/mob_slim.dmi',
		"slot_l_ear"     = 'icons/inv_slots/ears/mob_slim.dmi',
		//"slot_r_ear"     = 'icons/inv_slots/ears/mob_r_slim.dmi',
		"slot_wear_mask" = 'icons/inv_slots/masks/mob_slim.dmi',
		"slot_head"      = 'icons/inv_slots/hats/mob.dmi',
		"slot_shoes"     = 'icons/inv_slots/shoes/mob_slim.dmi',
		"slot_belt"      = 'icons/inv_slots/belts/mob_slim.dmi',
		"slot_s_store"   = 'icons/inv_slots/belts/belt_mirror.dmi',
		"slot_back"      = 'icons/inv_slots/back/mob_slim.dmi',
		"slot_tie"       = 'icons/inv_slots/neck/mob_slim.dmi',
		//"slot_hidden"    = 'icons/inv_slots/hidden/mob_slim.dmi',
		//"slot_wear_id"   = 'icons/mob/onmob/id.dmi',
		"slot_l_hand"    = 'icons/mob/inhands/items_lefthand.dmi',
		"slot_r_hand"    = 'icons/mob/inhands/items_righthand.dmi'
		)
	//rig_back             = 'icons/inv_slots/rig/mob_slim.dmi'
	//blood_icon           = 'icons/mob/human_races/masks/blood_human_slim.dmi'
	//dam_mask             = 'icons/mob/human_races/masks/dam_mask_human_slim.dmi'

/datum/body_build/slim/alt
	name                 = "Slim Alt"

	index                = "_slim_alt"
	genders              = list(FEMALE)
	clothing_icons       = list(
		"slot_w_uniform" = 'icons/inv_slots/uniforms/mob_slimalt.dmi',
		"slot_suit"      = 'icons/inv_slots/suits/mob_slimalt.dmi',
		"slot_gloves"    = 'icons/inv_slots/gloves/mob_slim.dmi',
		"slot_glasses"   = 'icons/inv_slots/glasses/mob_slim.dmi',
		"slot_l_ear"     = 'icons/inv_slots/ears/mob_slim.dmi',
		//"slot_r_ear"     = 'icons/inv_slots/ears/mob_r_slim.dmi',
		"slot_wear_mask" = 'icons/inv_slots/masks/mob_slim.dmi',
		"slot_head"      = 'icons/inv_slots/hats/mob.dmi',
		"slot_shoes"     = 'icons/inv_slots/shoes/mob_slimalt.dmi',
		"slot_belt"      = 'icons/inv_slots/belts/mob_slim.dmi',
		"slot_s_store"   = 'icons/inv_slots/belts/belt_mirror.dmi',
		"slot_back"      = 'icons/inv_slots/back/mob_slim.dmi',
		"slot_tie"       = 'icons/inv_slots/neck/mob_slim.dmi',
		//"slot_hidden"    = 'icons/inv_slots/hidden/mob_slimalt.dmi',
		//"slot_wear_id"   = 'icons/mob/onmob/id.dmi',
		"slot_l_hand"    = 'icons/mob/inhands/items_lefthand.dmi',
		"slot_r_hand"    = 'icons/mob/inhands/items_righthand.dmi'
		)
	//blood_icon           = 'icons/mob/human_races/masks/blood_human_slim_alt.dmi'
	//dam_mask             = 'icons/mob/human_races/masks/dam_mask_human_slim_alt.dmi'

/datum/body_build/slim/male
	name                 = "Slim"

	index                = "_slim"
	roboindex            = "_slim"
	genders              = list(MALE)
	clothing_icons       = list(
		"slot_w_uniform" = 'icons/inv_slots/uniforms/mob_slim_m.dmi',
		"slot_suit"      = 'icons/inv_slots/suits/mob_slim_m.dmi',
		"slot_gloves"    = 'icons/inv_slots/gloves/mob_slim.dmi',
		"slot_glasses"   = 'icons/inv_slots/glasses/mob_slim.dmi',
		"slot_l_ear"     = 'icons/inv_slots/ears/mob_slim.dmi',
		//"slot_r_ear"     = 'icons/inv_slots/ears/mob_r_slim.dmi',
		"slot_wear_mask" = 'icons/inv_slots/masks/mob_slim.dmi',
		"slot_head"      = 'icons/inv_slots/hats/mob.dmi',
		"slot_shoes"     = 'icons/inv_slots/shoes/mob_slim.dmi',
		"slot_belt"      = 'icons/inv_slots/belts/mob_slim.dmi',
		"slot_s_store"   = 'icons/inv_slots/belts/belt_mirror.dmi',
		"slot_back"      = 'icons/inv_slots/back/mob_slim_m.dmi',
		"slot_tie"       = 'icons/inv_slots/neck/mob_slim_m.dmi',
		//"slot_hidden"    = 'icons/inv_slots/hidden/mob_slim_m.dmi',
		//"slot_wear_id"   = 'icons/mob/onmob/id.dmi',
		"slot_l_hand"    = 'icons/mob/inhands/items_lefthand.dmi',
		"slot_r_hand"    = 'icons/mob/inhands/items_righthand.dmi'
		)
	//blood_icon           = 'icons/mob/human_races/masks/blood_human_m_slim.dmi'
	//dam_mask             = 'icons/mob/human_races/masks/dam_mask_human_m_slim.dmi'
