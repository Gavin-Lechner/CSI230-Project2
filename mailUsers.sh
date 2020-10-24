#!/bin/bash

USERNAME=" ";

#check if the user is root
if [ $USER != 'root' ]; then
   echo "Must run as root"    
   exit 1        
fi
#check if the csi230 group is created
if [ $(getent group CSI230) ]; then
   echo "CSI230 Is already a group"
else
   echo "creating group CSI230"
   groupadd CSI230
fi
#if the emails arent already users Create usernames by grabbing the first section of the email
while read line
do
USERNAME=$line | head -n1 | cut -d "@" -f1
PASSWORD=$(openssl passwd -1 "Password")
useradd -m -p $PASSWORD $USERNAME
done < 'addresses.txt'
#Create a random password using openssl for the user

#create the account if it doesn exist with the username, password, and a home directory and #that the default bash 

#make sure the user has to change their password when they first log in

#send the user an email with their initial username/password google "send a gmail from bash 2fa"

#delete the users for testing purposes
