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
   USERNAME=$(echo $line | head -n1 | cut -d "@" -f1)
#Create a random password using openssl for the user
   PASSWORD=$(openssl rand -base64 32)
#create the account if it doesnt exist with the username, password, and a home directory otherwise reset the password
   if id $USERNAME >/dev/null ; then
      echo "user exists, resetting password"
      usermod -p $(openssl passwd -1 $PASSWORD) ${USERNAME}
#make sure the user has to change their password when they first log in
      chage --lastday 0 ${USERNAME}
   else
      echo "user does not exist"
      useradd -m -G CSI230 ${USERNAME}
      usermod -p $(openssl passwd -1 $PASSWORD) ${USERNAME}
#make sure the user has to change their password when they first log in
      chage --lastday 0 ${USERNAME}
   fi
#send the user an email with their initial username/password google "send a gmail from bash 2fa"
   echo -e "Subject: New Linux Account Information\n\nHello ${USERNAME},\nYour account on Gavins Pop-Os Linux Machine has been reset your login credentials are listed here\nUsername:${USERNAME}\nPassword:${PASSWORD} \nYou will need to reset your password upon login.\n Have a Nice Day!\n\n Sincerely, \n     Gavin Lechner" | sendmail ${line}
done < 'addresses.txt'
exit 0
