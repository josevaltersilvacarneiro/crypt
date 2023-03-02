#!/bin/bash
#
# crypt.sh - It encrypts and decrypts files and storages your hashs
#
# Author   - José V S Carneiro
#
# ------------------------------------------------------------------
#
# This program receives as parameter what the user want to make (en-
# crypt, decrypt, delete non-existent files or inform the repeated
# files) and the path to which the user want to apply.
#
# Examples:
# 	$ crypt.sh -c /home/jose
#
# ------------------------------------------------------------------
#
# History:
#
# 	Version 0.1 2022-09-13, José V S Carneiro git@josevaltersilvacarneiro.net:
# 		- First Version
#
# Copyright: GPLv3

OLD_IFS=$IFS

function change_IFS()
{
	IFS=$(echo -ne "\n\b")
}

function retriev_IFS()
{
	IFS=$OLD_IFS
}

function is_file_encrypted()
{
	file="$1"

	[ "$file" != "${file%*.gpg}" ]

	return $?
}

function crypt_file()
{
	backup="$1"
	file="$2"

	echo -e "$1\t$2"
}

function crypt()
{
	backup="$1"
	filename="$2"

	if [ -d "$filename" ]
	then
		change_IFS
		for file in $(find "$filename" -mindepth 2 -type f)
		do
			is_file_encrypted "$file" || crypt_file "$backup" "$file"
		done
		retriev_IFS
	elif [ -f "$filename" ]
	then
		is_file_encrypted "$filename" || crypt_file "$backup" "$filename"
	else
		file_doenst_exist "$filename"
	fi
}

function decrypt()
{
	backup="$1"
	filename="$2"

	if [ -d "$filename" ]
	then
		change_IFS
		for file in $(find "$filename" -mindepth 2 -type f)
		do
			is_file_encrypted "$file" && decrypt_file "$backup" "$file"
		done
		retriev_IFS
	elif [ -f "$filename" ]
	then
		is_file_encrypted "$filename" && crypt_file "$backup" "$filename"
	else
		file_doenst_exist "$filename"
	fi
}

function delete()
{
	i=0
	while read line
	do
		let i++

		file=${line##* }

		if [ ! -e "$file" ]
		then
			echo "The file $file will be deleted of $backup because it doens't exist"
			sed -i "${i}d" "$backup"
		fi
	done < $backup
}

function show_duplicate_files()
{
	change_IFS
	for file in `sort "$backup" | uniq -d -w 128`
	do
		filnam=${file:130}
		echo "The file $filnam are repeated"
	done
	retriev_IFS
}

function support()
{
	echo "Type crypt.sh -[c, d, e, r, h[ path"
}

function main()
{
	# FILENAME receives the name of the file or direc- #
	# tory that should be encrypted. First the eval    #
	# command replaces the number of parameters passed #
	# as arguments to get the last argument which is   #
	# path to the file or directory.                   #

	FILENAME=`eval tr -s '/' \<\<\< \"\$\{$#\}\"`

	if [ -e "$FILENAME" ]
	then
		BACKUP="${FILENAME%/*}/.backup.sha512sum"
	else
		file_doenst_exist "$FILENAME"
		exit 1
	fi

	while true
	do
		PASSWORD=$(zenity --entry --title "Entry of the password" --text "Enter a password")
		[[ -n "$PASSWORD" ]] && break
	done

	# It verifies the pattern and delete the others    #
	# files that aren't in the pattern                 #

	[ -s "$BACKUP" ] && sed -i -r '/^[a-z0-9]{128}  .+$/!d' "$BACKUP"

	while getopts :cderh opt
	do
		case $opt in
			c)
				crypt "$BACKUP" "$FILENAME"
				;;
			d)
				decrypt
				;;
			e)
				delete
				;;
			r)
				repeat
				;;
			h)
				support
				;;
			\?)
				echo "The option '-$OPTARG' doens't exist" >&2
				exit 2
		esac
	done
}

main $@
