#!/bin/bash
#
# Description:	This script will replace tokens in the config.ini file with their corresponding actual values
# Usage:	./configure.sh	--host sample.server.com --admin admin@email.com \
#		--port 0000 --root /local/content/ --out /tmp \
#		--url tcp://queue:9999 --name /queue --error /error

# create hash for parameters
declare -A parameters=( [host]= [admin]= [username]= [password]= )
valid=true

# assign arguments to parameters
while true; do
	# if parameter matches --*, then assign its value to the corresponding key
	[[ $1 == --* ]] && parameters[${1:2}]=$2 && shift 2 || break
done

# display any error messages
for key in "${!parameters[@]}"; do
	[ -z "${parameters[$key]}" ] && echo -e "\e[91m[error]\e[39m missing parameter:\e[93m $key \e[39m" && valid=false
done

# replace tokens in config.ini file
if [ $valid = true ]; then

	for key in "${!parameters[@]}"; do
		sed -i "s|\@${key}@|${parameters[$key]}|g" config.ini
	done

	echo -e "\e[92mNCIDose configured successfully\e[39m"

# display usage if incorrect
else
	echo
	
	echo -e "\e[32mUsage:"
	echo -e "\e[95m	sh\e[39m configure.sh \e[92m[options]"
	
	echo -e "\e[32mOptions:"
	echo -e "\e[39m	--host\e[92m server.name"
	echo -e "\e[39m	--admin\e[92m admin@server.name"
	echo -e "\e[39m	--username\e[92m username"
	echo -e "\e[39m	--password\e[92m password"


fi
