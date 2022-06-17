#!/bin/bash

# This script will generate a random password

PASSWORD=${RANDOM}

echo "${PASSWORD}"

PASSWORD=${RANDOM}${RANDOM}${RANDOM}

echo "${PASSWORD}"

PASSWORD=$(date +%s)

echo "${PASSWORD}"

PASSWORD=$(date +%s%N)

echo "${PASSWORD}"

PASSWORD=$(echo ${PASSWORD} | sha256sum | head -c32)

echo "${PASSWORD}"

SPECIAL_CHARACTER=$(echo "!@#$%^&*()_-=+" | fold -w1 | shuf | head -c1)

echo "${SPECIAL_CHARACTER}"