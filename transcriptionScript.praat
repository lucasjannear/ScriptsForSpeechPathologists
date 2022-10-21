#This script creates a praat textgrid to be used for transcribing
#a language or intelligibility sample.
#Once the textgrid has been created, you will have the option of
#having each utterance chunked into individual sound files.

#The core of this script (creating textgrids) was borrowed from user sjcs @ https://gist.github.com/scjs
#The rest was written by Luke Annear (for questions on usage, lucas.annear@gmail.com)


form Settings
    comment Check settings and then press OK to choose a directory of sound files to annotate.
    comment Default settings will create a Praat textgrid with one tier for marking and transcribing utterances.
    sentence Interval_tiers Transcription
    sentence Point_tiers 
    optionmenu If_TextGrid_already_exists: 3
        option skip the sound file
        option create a TextGrid with a different filename
        option open and edit the existing TextGrid
    word Sound_file_extension .MP3

endform

directory$ = chooseDirectory$: "Choose a directory with 'sound_file_extension$'
... files to annotate."
@getFiles: directory$, sound_file_extension$

tiers$ = interval_tiers$ + " " + point_tiers$

for i to getFiles.length
    soundfile = Read from file: getFiles.files$ [i]

    @getTextGrid: getFiles.files$ [i]

    if !fileReadable (getTextGrid.path$) or if_TextGrid_already_exists > 1
        selectObject: soundfile, getTextGrid.textgrid
        
	View & Edit
	
	editor: getTextGrid.textgrid

        	beginPause: "Annotate and chunk audio"
            	comment: "Press OK when done to save TextGrid and chunk audio."

	        endPause: "OK", 0

	endeditor

        selectObject: getTextGrid.textgrid
        Save as text file: getTextGrid.path$

        #removeObject: getTextGrid.textgrid

	
	@name
	@chunkAudio

	fappendinfo 'directory$'/ClinicianTranscriptions.txt

    endif


    #removeObject: soundfile

endfor

###############
#PROCEDURES####
###############

procedure getTextGrid: .soundfile$
    .path$ = replace$: .soundfile$, sound_file_extension$, ".TextGrid", 0

    if !fileReadable: .path$
        .textgrid = To TextGrid: tiers$, point_tiers$

    elif if_TextGrid_already_exists == 2
        .textgrid = To TextGrid: tiers$, point_tiers$
        .default$ = mid$: .path$, rindex (.path$, "/") + 1, length (.path$)
        .default$ = replace$: .default$, sound_file_extension$, ".TextGrid", 1

        .path$ = chooseWriteFile$: "TextGrid already exists in this directory. 
        ... Choose where to save the new TextGrid.", .default$

    elif if_TextGrid_already_exists == 3
        .textgrid = Read from file: .path$

    endif

endproc

procedure getFiles: .dir$, .ext$
    .obj = Create Strings as file list: "files", .dir$ + "/*" + .ext$
    .length = Get number of strings

    for .i to .length
        .fname$ = Get string: .i
        .files$ [.i] = .dir$ + "/" + .fname$

    endfor

    removeObject: .obj

endproc

###################################################################	

procedure chunkAudio

	clearinfo
	printline "clinician transcriptions"

	.loop1 = Get number of intervals: 1

	selectObject: soundfile, getTextGrid.textgrid

	View & Edit
	editor: getTextGrid.textgrid
		Move cursor to... 0
	endeditor

	#minusObject: "Sound 'objName$'", "TextGrid 'objName$'"

	.uttNumb = 0

	for i from 1 to .loop1-1

		selectObject: soundfile, getTextGrid.textgrid

		editor: getTextGrid.textgrid

			Select next interval
			.label$ = Get label of interval
		
			if .label$ != ""
				@renameClip
			else
				endeditor
			endif
	
	endfor

endproc


procedure renameClip

	chunkAudio.uttNumb = chunkAudio.uttNumb + 1
	
	if chunkAudio.uttNumb < 10
		.uttName$ = "utterance"+"0"+"'chunkAudio.uttNumb'"
	elsif chunkAudio.uttNumb >= 10 
		.uttName$ = "utterance"+"'chunkAudio.uttNumb'"
	endif
	
	Extract selected sound (time from 0)
	
	endeditor

	selectObject: "Sound untitled"
	.untitledSound = selected ("Sound untitled")
	Rename: "'.uttName$'"
	
	createDirectory("'directory$'/Intelligibility")
	Save as WAV file: "'directory$'/Intelligibility/'name.name$'_'.uttName$'.wav"
	removeObject: .untitledSound
	printline '.uttName$''tab$''chunkAudio.label$'

endproc


procedure name

	beginPause: "Student name"
		sentence: "lastName", ""
		sentence: "firstName", ""
	endPause: "OKAY", 1

	.name$ = lastName$+firstName$

endproc