# Use this script to enter therapy data for kids.
# Simply follow the prompts.
# Data for each kid will be saved in a folder with the kid's last name
# followed by first name (e.g., "AnnearLuke"), inside of a folder
# called "TherapyData". e.g. H:/TherapyData
# For usage or other questions, contact lucas.annear@gmail.com
# v2.5 update: Allows user to manually select data storage location.

# type ctrl + r to run.



@startScript

sessionType = 1

@getDate

#Use "date$" variable immediately below in place of "'getDate.numDay$'" variable in the form below
#to make a previous date entry stick when entering therapy notes from previous days.
date$ = getDate.numDay$
#thisYear$ = "2020-2021"

repeat
	clearinfo
	beginPause: "Therapy Data"
		comment: "Enter date only as numbers and don't include the year."
		comment: "For example, April 4th = 0404. December 25th = 1225"
		sentence: "year", "'getDate.acadYear$'"
		sentence: "quarter", "'getQuarter.quarter'"
		sentence: "lastName", ""
		sentence: "firstName", ""
		sentence: "date", "'date$'"
		sentence: "time", ""
		sentence: "minutes", ""
		optionMenu: "sessionType", sessionType
			option: "IP_Group"
			option: "IP_Individual"
			option: "Virtual_Group"
			option: "Virtual_Individual"
			option: "Missed"
			option: "MakeUp"
		comment: "Enter therapy data in the blank space below"
		text: "dataEntry", ""
	clicked = endPause: "Make Entry", "Done", 1

	 
	folder$ = "'startScript.dataFolder$'"
	#printline: 'folder$'


	# check to see if "TherapyData" folder has been made yet. If not, make folder.
	if fileReadable ("'folder$'/blank.txt")
		#do nothing
	else 
		createDirectory(folder$)
		writeFile: "'folder$'/blank.txt", "blank"
	endif

	# check to see if "year" folder has been made yet. If not make folder.
	if fileReadable ("'folder$'/'year$'/blank.txt")
		#do nothing
	else 
		createDirectory("'folder$'/'year$'")
		writeFile: "'folder$'/'year$'/blank.txt", "blank"
	endif

	# check to see if "quarter" folder has been made yet. If not make folder.
	if fileReadable ("'folder$'/'year$'/quarter'quarter$'/blank.txt")
		#do nothing
	else 
		createDirectory("'folder$'/'year$'/quarter'quarter$'")
		writeFile: "'folder$'/'year$'/quarter'quarter$'/blank.txt", "blank"
	endif

	# check to see if "date" folder has been made yet. If not make folder
	if fileReadable ("'folder$'/'year$'/quarter'quarter$'/'date$'/blank.txt")
		#do nothing
	else 
		createDirectory("'folder$'/'year$'/quarter'quarter$'/'date$'")
		writeFile: "'folder$'/'year$'/quarter'quarter$'/'date$'/blank.txt", "blank"
	endif


	outputFolder$ = "'folder$'/'year$'/quarter'quarter$'"



	if clicked = 1
		printline 'date$'
		printline 'lastName$''firstName$'
		printline 'sessionType$'
		printline 'minutes$' minutes
		
		if time$ != ""
			printline 'time$'
		else
		endif
		
		print 'dataEntry$'
		printline
		printline
		printline
		
		
		# save file. first make and append all therapy for the day into one file. 
		# then save to student's file.

		fappendinfo 'outputFolder$'/'date$'/'date$''year$'_TherapyData.txt
		if fileReadable ("'outputFolder$'/'lastName$''firstName$'_TherapyData.txt")
			fappendinfo 'outputFolder$'/'lastName$''firstName$'_TherapyData.txt
		else
			#createDirectory("'outputFolder$'")
			fappendinfo 'outputFolder$'/'lastName$''firstName$'_TherapyData.txt
		endif


		# If session missed or was virtual, save to missed or virtual file as well.

		if sessionType$ = "Missed"
			@missedSession
		elsif sessionType$ = "MakeUp"
			@missedSession
		elsif sessionType$ = "Virtual_Group"
			@virtualSession
		elsif sessionType$ = "Virtual_Individual"
			@virtualSession
		endif
				
	endif

until clicked = 2


###############
#PROCEDURES####
###############


procedure startScript

	beginPause: "Save location"
		comment: "Select where to save data?"
	clicked = endPause: "Select folder location", "No, continue", 1

	if clicked = 1
		.directory$ = chooseDirectory$: "Choose a directory where you would like to create your TherapyData folder."
		printline '.directory$'
		.dataFolder$ = "'.directory$'/TherapyData"
		writeFile: "/TherapyDataLocation.txt", "'.dataFolder$'"
		createDirectory(.dataFolder$)
		writeFile: "'.dataFolder$'/blank.txt", "blank"

	elsif clicked = 2
		#@getLocation
		#if fileReadable ("Desktop/TherapyDataLocation.txt")
		
		location = Read Strings from raw text file... TherapyDataLocation.txt
		.dataFolder$ = Get string... location
		printline '.dataFolder$'
		#else
		#endif

	endif

endproc


procedure makeLocation

	.dataFolder$ = "'startScript.directory$'/TherapyData"
	createDirectory(.dataFolder$)
	writeFile: "'.folder$'/blank.txt", "blank"

endproc



procedure getLocation

	if fileReadable ("Desktop/TherapyDataLocation.txt")
		location = Read Strings from raw text file... TherapyDataLocation.txt
		.folder$ = Get string: location
		printline '.folder$'
	else
	endif
	

endproc



procedure getDate

	.date$ = date$()

	.year$ = right$(.date$, 4)
	
	.year = number(.year$)

	.yearLess = .year - 1
	.yearLess$ = string$(.yearLess)

	.yearMore = .year + 1
	.yearMore$ = string$(.yearMore)

	.month$ = mid$(.date$, 5, 3)

	.zero = 0
	.zero$ = string$(.zero)

	.day$ = mid$ (.date$, 9, 2)
		.day = number(.day$)
		.d$ = string$(.day)
		if .day < 10
			.dayNumb$ = "'.zero$'" + "'.d$'"
		else
			.dayNumb$ = .d$
		endif

	#printline '.dayNumb$'

	month$ = "'.dayNumb$'" + "'.month$'"
	#printline 'month$'

#Redefine Month

	if .month$ = "Jan"
		.mNum = 1
		@getQuarter
	elsif .month$ = "Feb"
		.mNum = 2
		@getQuarter
	elsif .month$ = "Mar"
		.mNum = 3
		@getQuarter
	elsif .month$ = "Apr"
		.mNum = 4
		@getQuarter
	elsif .month$ = "May"
		.mNum = 5
		@getQuarter	
	elsif .month$ = "Jun"
		.mNum = 6
		@getQuarter
	elsif .month$ = "Jul"
		.mNum = 7
	elsif .month$ = "Aug"
		.mNum = 8
		@getQuarter
	elsif .month$ = "Sep"
		.mNum = 9
		@getQuarter
	elsif .month$ = "Oct"
		.mNum = 10
		@getQuarter
	elsif .month$ = "Nov"
		.mNum = 11
		@getQuarter
	elsif .month$ = "Dec"
		.mNum = 12
		@getQuarter
	endif

	
	#printline '.mNum'
	.m$ = string$(.mNum)


	if .mNum < 10
		.mNum$ = "0" + "'.m$'"
	else
		.mNum$ = .m$
	endif

	#printline '.mNum$'
	
	.numDay$ = "'.mNum$'" + "'.dayNumb$'"

	if .mNum < 7
		.acadYear$ = "'.yearLess$'" + "-" + "'.year$'"
	elsif .mNum > 7
		.acadYear$ = "'.year$'" + "-" + "'.yearMore$'"
	endif

endproc


procedure getQuarter

	if getDate.mNum = 08
		.quarter = 1
	elsif getDate.mNum = 09
		.quarter = 1
	elsif getDate.mNum = 10
		.quarter = 1	

	elsif getDate.mNum = 11
		if getDate.day <= 5
			.quarter = 1
		else
			.quarter = 2
		endif

	elsif getDate.mNum = 12
		.quarter = 2

	elsif getDate.mNum = 01
		if getDate.day <= 21
			.quarter = 2
		else
			.quarter = 3
		endif

	elsif getDate.mNum = 02
		.quarter = 3
	
	elsif getDate.mNum = 03
		if getDate.day <= 25
			.quarter = 3
		else
			.quarter = 4
		endif

	else
		.quarter = 4
	endif

endproc




procedure missedSession
	if fileReadable("'outputFolder$'/MissedSessions/quarter'quarter$'_MissedSessions.txt")
		fappendinfo 'outputFolder$'/MissedSessions/quarter'quarter$'_MissedSessions.txt
	else
		createDirectory("'outputFolder$'/MissedSessions")
		writeFile: "'outputFolder$'/MissedSessions/quarter'quarter$'_MissedSessions.txt"
		fappendinfo 'outputFolder$'/MissedSessions/quarter'quarter$'_MissedSessions.txt
	endif
endproc



procedure virtualSession
	if fileReadable("'outputFolder$'/VirtualSessions/quarter'quarter$'_VirtualSessions.txt")
		fappendinfo 'outputFolder$'/VirtualSessions/quarter'quarter$'_VirtualSessions.txt
	else
		createDirectory("'outputFolder$'/VirtualSessions")
		writeFile: "'outputFolder$'/VirtualSessions/quarter'quarter$'_VirtualSessions.txt"
		fappendinfo 'outputFolder$'/VirtualSessions/quarter'quarter$'_VirtualSessions.txt
	endif
endproc


############################