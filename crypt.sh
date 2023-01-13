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
