#!/bin/bash

######################################################################################################################
# With this script you can add, update and remove multiple cronjobs at once, while only updating the cronjobs in the #
# block specified by the first passed argument. All other cronjobs will be left untouched.                           #
#                                                                                                                    #
# Usage:                                                                                                             #
#   echo ${CRONJOBS} | ./vendor/ujamii/update-cronjobs/update-cronjobs.sh "My great project"                         #
#                                                                                                                    #
# To remove the whole block, including start and end markers:                                                        #
#   ./vendor/ujamii/update-cronjobs/update-cronjobs.sh "My great project" -r                                         #
#                                                                                                                    #
######################################################################################################################

# Set the name specified for the cronjob start and end markers
CRONJOBS_NAME=$1

# Set markers
CRONJOBS_STARTMARKER="#---- ${CRONJOBS_NAME} cronjobs start here ----#"
CRONJOBS_ENDMARKER="#---- ${CRONJOBS_NAME} cronjobs end here ------#"

# Load current crontab content
CRONTAB_CONTENT=$(crontab -l 2> /dev/null)

# Add start and end markers for the cronjobs if they are not present yet
if [[ ${CRONTAB_CONTENT} != ${CRONJOBS_STARTMARKER}*${CRONJOBS_ENDMARKER} ]]
then
	read -r -d '' CRONTAB_CONTENT <<-EOF
		${CRONTAB_CONTENT}

		${CRONJOBS_STARTMARKER}
		# ${CRONJOBS_NAME} jobs go here
		${CRONJOBS_ENDMARKER}
	EOF
fi

# Check if remove flag is set
if [[ $2 == '-r' ]]
then
	# Remove jobs from crontab
	echo -n "${CRONTAB_CONTENT//${CRONJOBS_STARTMARKER}*${CRONJOBS_ENDMARKER}/}" | crontab -
	exit
fi

# Read jobs from standard input
read -r -d '' CRONJOBS_CONTENT

# Combine markers and content
read -r -d '' CRONJOBS_CONTENT_COMBINED <<-EOF
	${CRONJOBS_STARTMARKER}
	${CRONJOBS_CONTENT}
	${CRONJOBS_ENDMARKER}
EOF

# Update crontab with the updated jobs code
echo "${CRONTAB_CONTENT//${CRONJOBS_STARTMARKER}*${CRONJOBS_ENDMARKER}/${CRONJOBS_CONTENT_COMBINED}}" | crontab -
