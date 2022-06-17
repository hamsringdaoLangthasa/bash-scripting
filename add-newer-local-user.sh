#!/bin/bash

# This script creates a new user and redirects STDOUT and STDERR to a file.

# Make sure the script is being executed with superuser privileges.
if [[ "$UID" != 0 ]]
then
    echo "Please run as root or with sudo" >&2
    exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
if [[ "$#" < 1 ]]
then
    echo "Usage: $0 USERNAME [COMMENT]..." >&2
    exit 1
fi

# The first parameter is the user name.
USERNAME=$1

# The rest of the parameters are for the account comments.
shift
COMMENT=$@

# Generate a password.
PASSWORD=$(echo ${RANDOM}${RANDOM} | sha256sum | head -c48)

# Create the user with the password.
useradd -c "${COMMENT}" -m "${USERNAME}" &> /dev/null

# Check to see if the useradd command succeeded.
if [[ "$?" != 0 ]]
then
    echo "Account for ${USERNAME} is not created" >&2
    exit 1
fi

# Set the password.
echo "${USERNAME}:${PASSWORD}" | chpasswd &> /dev/null

# Check to see if the passwd command succeeded.
if [[ "${?}" != 0 ]]
then
    echo " Password is not created for ${USERNAME}" >&2
    exit 1
fi

# Force password change on first login.
passwd -e "${USERNAME}" &> /dev/null

# Display the username, password, and the host where the user was created.
echo
echo "USERNAME: ${USERNAME}"
echo
echo "PASSWORD: ${PASSWORD}"
