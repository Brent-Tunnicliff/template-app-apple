#!/bin/bash

NEW_NAME=$1

if [ -z "$NEW_NAME" ]
  then
    echo "Error: No name supplied"
    exit 1
fi



NAME_TO_REPLACE="REPLACE_ME"
SCRIPT=$(realpath "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
ROOT_PAH=$(dirname "$SCRIPT_PATH")

echo "Renaming $NAME_TO_REPLACE to $NEW_NAME"
echo "Processing files at $ROOT_PAH"

function process_file() {
	FILE=$1
	FILE_NAME=$(basename $FILE)

	if [ "$FILE" == "$SCRIPT" ]; then
    	return
	fi

	if [[ "$FILE_NAME" != *"$NAME_TO_REPLACE"* ]]; then
    	return
	fi

    echo $FILE
}

function process_directory() {
	DIRECTORY=$1
	DIRECTORY_NAME=$(basename $DIRECTORY)

	if [[ "$DIRECTORY_NAME" != *$NAME_TO_REPLACE* ]]; then
    	return
	fi

	echo $DIRECTORY
}

find $ROOT_PAH -print0 |
	sort -z -r |
  	while read -r -d "" FILE; do
  		if [[ "$FILE" == *".build"* || "$FILE" == *".git"* || "$FILE" == *".bundle"* ]]; then
  			continue
  		elif [ -f "$FILE" ]; then
  			process_file "$FILE"
		else
			if [ -d "$FILE" ]; then
				process_directory "$FILE"
			fi
		fi
	done