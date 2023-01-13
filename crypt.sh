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

function crypt()
{
	if [ -s "$backup" ]
	then
		if [ -d "$filename" ]
		then
			change_IFS
			for file in $(find "$filename" -mindepth 2 -type f)
			do
				if [ is_file_stored "$file" -eq 1]
				then
					crypt_file "$file"
				fi
			done
			retriev_IFS
		elif [ -f "$filename" ]
		then
			if [ is_file_stored "$filename" -eq 1]
			then
				crypt_file "$file"
			fi
		else
			file_doenst_exist
		fi
	else
		if [ -d "$filename" ]
		then
			change_IFS
			for file in $(find "$filename" -mindepth 2 -type f)
			do
				crypt_file "$file"
			done
			retriev_IFS
		elif [ -f "$filename" ]
		then
			crypt_file "$filename"
		else
			file_doenst_exist
		fi
	fi
}

function decrypt()
{
	if [ -s "$backup" ]
	then
		if [ -d "$filename" ]
		then
			change_IFS
			for file in $()
			do
				if [ is_file_intact "$file" -eq 1]
				then
					decrypt_file "$file"
				fi
			done
		elif [ -f "$filename" ]
		then
				if [ is_file_intact "$filename" -eq 1]
				then
					decrypt_file "$file"
				fi
		else
			file_doenst_exist
		fi
	else
			echo "Could not decrypt any file because the file `$backup` doens't exist"
	fi
}

function main()
{
	while getoppts :cderh opt
	do
		case $opt in
			c)
				echo "Crypting"
				crypt
				;;
			d)
				echo "Decrypting"
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
