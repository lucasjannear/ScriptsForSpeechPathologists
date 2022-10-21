# ScriptsForSpeechPathologists
Transcribing speech samples, measuring intelligibility, and writing therapy notes

This repository contains several scripts that are designed to facilitate common tasks performed by speech-language pathologists.

- Intelligibility Package
  - transcriptionScript.Praat
    - transcriptionScript.praat allows you to transcribe and listen to a speech sample all in one window using the program Praat. 
      When you have completed transcription, the script creates individual audio files for each utterance in the sample and saves them 
      to a folder where your speech sample is located called "Intelligibility". Each audio/utterance file is saved using the child's name and utterance number 
      (e.g. "StudentExample_utterance01.wav").
      Your clinician transcriptions of each utterance are saved as "ClinicianTranscriptions.txt" in the same folder where you have the original 
      audio recording saved.
    

  - IntelligibilityScript.praat
    - This script uses the individual audio files created by transcriptionScript.praat and plays them to a listener of your choice for transcription.
      The script takes the listener through the individual utterance files one-by-one so they can listen to each one time and transcribe what they heard.
      The listeners's transcriptions are saved within the "Intelligibility" folder that contains each of the individual audio files of the utterances.



- therapyDataScript.Praat
  - This script helps you organize and store your therapy data for kids in simple text files that are easy to copy for the purposes of entering billing, etc.
    Simply by making sure the fields such as, "year", "date", and "quarter" are accurate when you enter notes, notes are saved in folders by
    Year, Quarter, Date, and Child. This makes it easy to look at notes from a specific date, or to look at all of the notes for a single child in a given quarter.
