# Use this script to allow an unfamiliar listener to listen to audio clips and transcribe
# the speech they hear for intelligibility ratings.
# NB transcriptions are saved as "Intelligibility.txt"
# Written by Luke Annear (lucas.annear AT gmail DOT com)

call start

procedure start

	#get the path

	dirName$ = chooseDirectory$: "Choose the directory containing
	... the intelligibility files"

	Create Strings as file list... fileList 'dirName$'/*.wav
	numberOfFiles = Get number of strings
	clearinfo
	call cycleThrough

	fappendinfo 'dirName$'/Intelligibility.txt

endproc


procedure cycleThrough

	for thisFile from 1 to numberOfFiles
		select Strings fileList
		filename$ = Get string... thisFile
		name$ = "'filename$'" - ".wav"
		wavName$ = "'dirName$'/'name$'.wav"
		if fileReadable (wavName$)
			Read from file... 'dirName$'/'name$'.wav
			
			objName$ = selected$ ("Sound")

			beginPause: "Listen to utterance"
				comment: "click play when ready"
			clicked = endPause: "Play file", 1

			Play

			beginPause: "Transcription"
				comment: "Transcribe what you understood."
				sentence: "transcription", ""
			clicked = endPause: "Continue", 1

			printline 'objName$''tab$''tab$''transcription$'

			#Close
			#endeditor

			Remove
		
		else
		endif
	endfor

	select Strings fileList
	Remove

endproc
