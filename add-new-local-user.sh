#!/bin/bash

# This script creates a new user on the local systems.

# Make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
    echo "Execute the script with sudo or as root"
    exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
if [[ "${#}" -lt 1 ]]
then
    echo "Usage: ${0} USER_NAME [COMMENT]..."
    exit 1
fi

# The first parameter is the user name.
USERNAME="${1}"

# The rest of the parameters are for the account comments.
shift
COMMENT="${@}"

# Generate a password.
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USERNAME}

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
    echo "${USERNAME} is not created"
    exit 1
fi

# Set the password.
echo ${USERNAME}:${PASSWORD} | chpasswd

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
    echo "Password for ${USERNAME} is not created"
    exit 1
fi

# Force password change on first login.
passwd -e ${USERNAME}

# Display the username, password, and the host where the user was created.
echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"
exit 0