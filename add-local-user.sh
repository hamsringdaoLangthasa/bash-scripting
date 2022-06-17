#!/bin/bash

# This script creates a new user on the local system.

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo "Execute the script with superuser privileges"
    exit 1
fi

# Get the username (login).
read -p "Enter a username: " USER_NAME

# Get the real name (contents for the description field).
read -p "Enter a real name: " COMMENT

# Get the password.
read -p "Enter a password: " PASSWORD

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if the useradd command succeeded.
if [[ "${?}" -eq 0 ]]
then
    echo "User ${USER_NAME} is created successfully"
else
    echo "User ${USER_NAME} is not created"
    exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Check to see if the passwd command succeeded.
if [[ "${?}" -eq 0 ]]
then
    echo "Password ${PASSWORD} is set successfuly for ${USER_NAME}"
else
    echo "Password ${PASSWORD} is not set for ${USER_NAME}"
    exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo "${USER_NAME} successfully created using ${PASSWORD} on ${HOSTNAME}"
exit 0