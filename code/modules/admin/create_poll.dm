/client/proc/create_poll()
	set name = "Create Poll"
	set category = "Adminbus"
	if(!check_rights(R_POLL))
		return
	if(!SSdbcore.Connect())
		to_chat(src, "<span class='danger'>Failed to establish database connection.</span>", confidential = TRUE)
		return
	var/polltype = input("Choose poll type.","Poll Type") as null|anything in list("Single Option","Text Reply","Rating","Multiple Choice", "Instant Runoff Voting")
	var/choice_amount = 0
	switch(polltype)
		if("Single Option")
			polltype = POLLTYPE_OPTION
		if("Text Reply")
			polltype = POLLTYPE_TEXT
		if("Rating")
			polltype = POLLTYPE_RATING
		if("Multiple Choice")
			polltype = POLLTYPE_MULTI
			choice_amount = input("How many choices should be allowed?","Select choice amount") as num|null
			switch(choice_amount)
				if(0)
					to_chat(src, "Multiple choice poll must have at least one choice allowed.", confidential = TRUE)
					return
				if(1)
					polltype = POLLTYPE_OPTION
				if(null)
					return
		if ("Instant Runoff Voting")
			polltype = POLLTYPE_IRV
		else
			return 0
	var/starttime = SQLtime()
	var/endtime = capped_input(usr, "Set end time for poll as format YYYY-MM-DD HH:MM:SS. All times in server time. HH:MM:SS is optional and 24-hour. Must be later than starting time for obvious reasons.", "Set end time", SQLtime())
	if(!endtime)
		return
	var/datum/DBQuery/query_validate_time = SSdbcore.NewQuery("SELECT IF(STR_TO_DATE('[endtime]','%Y-%c-%d %T') > NOW(), STR_TO_DATE('[endtime]','%Y-%c-%d %T'), 0)")
	if(!query_validate_time.warn_execute() || QDELETED(usr) || !src)
		qdel(query_validate_time)
		return
	if(query_validate_time.NextRow())
		var/checktime = text2num(query_validate_time.item[1])
		if(!checktime)
			to_chat(src, "Datetime entered is improperly formatted or not later than current server time.", confidential = TRUE)
			qdel(query_validate_time)
			return
		endtime = query_validate_time.item[1]
	qdel(query_validate_time)
	var/adminonly
	switch(alert("Admin only poll?",,"Yes","No","Cancel"))
		if("Yes")
			adminonly = 1
		if("No")
			adminonly = 0
		else
			return
	var/dontshow
	switch(alert("Hide poll results from tracking until completed?",,"Yes","No","Cancel"))
		if("Yes")
			dontshow = 1
		if("No")
			dontshow = 0
		else
			return
	var/sql_ckey = sanitizeSQL(ckey)
	var/question = capped_multiline_input(usr, "Write your question","Question")
	if(!question)
		return
	var/list/sql_option_list = list()
	if(polltype != POLLTYPE_TEXT)
		var/add_option = 1
		while(add_option)
			var/option = capped_multiline_input(usr, "Write your option","Option")
			if(!option)
				return
			var/default_percentage_calc = 0
			if(polltype != POLLTYPE_IRV)
				switch(alert("Should this option be included by default when poll result percentages are generated?",,"Yes","No","Cancel"))
					if("Yes")
						default_percentage_calc = 1
					if("No")
						default_percentage_calc = 0
					else
						return
			var/minval = 0
			var/maxval = 0
			var/descmin = ""
			var/descmid = ""
			var/descmax = ""
			if(polltype == POLLTYPE_RATING)
				minval = input("Set minimum rating value.","Minimum rating") as num|null
				if(minval == null)
					return
				maxval = input("Set maximum rating value.","Maximum rating") as num|null
				if(minval >= maxval)
					to_chat(src, "Maximum rating value can't be less than or equal to minimum rating value", confidential = TRUE)
					continue
				else if(maxval == null)
					return
				descmin = capped_multiline_input(src, "Optional: Set description for minimum rating","Minimum rating description")
				if(descmin == null)
					return
				descmid = capped_multiline_input(src, "Optional: Set description for median rating","Median rating description")
				if(descmid == null)
					return
				descmax = capped_multiline_input(src, "Optional: Set description for maximum rating","Maximum rating description")
				if(descmax == null)
					return
			sql_option_list += list(list("text" = "'[option]'", "minval" = "'[minval]'", "maxval" = "'[maxval]'", "descmin" = "'[descmin]'", "descmid" = "'[descmid]'", "descmax" = "'[descmax]'", "default_percentage_calc" = "'[default_percentage_calc]'"))
			switch(alert(" ",,"Add option","Finish", "Cancel"))
				if("Add option")
					add_option = 1
				if("Finish")
					add_option = 0
				else
					return 0

	var/minimum_player_playtime = input("Minimum player playtime to vote (in hours)","Minimum playtime") as num|null
	if (minimum_player_playtime == null)
		minimum_player_playtime = 0
	minimum_player_playtime = min(minimum_player_playtime, 100) //max 100 hours

	var/m1 = "[key_name(usr)] has created a new server poll. Poll type: [polltype] - Admin Only: [adminonly ? "Yes" : "No"] - Question: [question]"
	var/m2 = "[key_name_admin(usr)] has created a new server poll. Poll type: [polltype] - Admin Only: [adminonly ? "Yes" : "No"]<br>Question: [question]"
	var/datum/DBQuery/query_polladd_question = SSdbcore.NewQuery("INSERT INTO [format_table_name("poll_question")] (polltype, starttime, endtime, question, adminonly, multiplechoiceoptions, createdby_ckey, createdby_ip, dontshow, minimumplaytime) VALUES ('[polltype]', '[starttime]', '[endtime]', '[question]', '[adminonly]', '[choice_amount]', '[sql_ckey]', INET_ATON('[address]'), '[dontshow]', '[minimum_player_playtime]')")
	if(!query_polladd_question.warn_execute())
		qdel(query_polladd_question)
		return
	qdel(query_polladd_question)
	if(polltype != POLLTYPE_TEXT)
		var/pollid = 0
		var/datum/DBQuery/query_get_id = SSdbcore.NewQuery("SELECT LAST_INSERT_ID()")
		if(!query_get_id.warn_execute())
			qdel(query_get_id)
			return
		if(query_get_id.NextRow())
			pollid = query_get_id.item[1]
		qdel(query_get_id)
		for(var/list/i in sql_option_list)
			i |= list("pollid" = "'[pollid]'")
		SSdbcore.MassInsert(format_table_name("poll_option"), sql_option_list, warn = 1)
	log_admin(m1)
	message_admins(m2)
