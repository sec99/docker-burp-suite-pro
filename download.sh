#!/bin/sh

email="$PORTSWIGGER_EMAIL_ADDRESS"
password="$PORTSWIGGER_PASSWORD"

name="burpsuite_pro"
version="$BURP_SUITE_PRO_VERSION"
file_name="$HOME/${name}_v$version.jar"
checksum="$BURP_SUITE_PRO_CHECKSUM"

cookie_jar="$HOME/cookies"

# Make initial request to get the 'request verification token' (CSRF).
token=$(curl -s --cookie-jar "$cookie_jar" "https://portswigger.net/users" | grep -oE "[A-Z0-9_-]{128}")

# Login using the username (email address) and password.
curl https://portswigger.net/users \
  -b "$cookie_jar" \
  -c "$cookie_jar" \
  -F "EmailAddress=$email" \
  -F "Password=$password" \
  -F "__RequestVerificationToken=$token"

# Download the JAR file.
curl -b "$cookie_jar" \
  -o "$file_name" \
  "https://portswigger.net/burp/releases/download?product=pro&version=$version&type=Jar" -v

echo "$checksum *$file_name" | sha256sum -c || exit
