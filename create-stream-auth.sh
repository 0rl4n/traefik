#!/bin/bash

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "Please do not run as root"
    exit 1
fi

# Check if htpasswd is installed
if ! command -v htpasswd &> /dev/null; then
    echo "htpasswd not found. Installing apache2-utils..."
    sudo apt-get update
    sudo apt-get install -y apache2-utils
fi

# Prompt for credentials
read -p "Enter username: " USERNAME
read -s -p "Enter password: " PASSWORD
echo  # New line after password input
read -s -p "Confirm password: " PASSWORD2
echo  # New line after password confirmation

# Check if passwords match
if [ "$PASSWORD" != "$PASSWORD2" ]; then
    echo "Passwords do not match!"
    exit 1
fi

# Create stream_auth file
if htpasswd -nb "$USERNAME" "$PASSWORD" > stream_auth; then
    chmod 600 stream_auth
    echo "Auth file created successfully at $(pwd)/stream_auth"
else
    echo "Failed to create auth file"
    exit 1
fi
