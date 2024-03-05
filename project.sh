#!/bin/bash

# adduser
adduser() {
read -p "Please enter username: " username
id $username &>/dev/null

while [ $? -eq 0 ]
do
username=${username}${RANDOM}
id $username &>/dev/null
done

sudo useradd $username
read -p "Please enter password: " password
echo $password | passwd --stdin $username
echo "User $username added successfully"
}

# delete user
deleteuser() {
read -p "Please enter username you want to delete: " username
sudo userdel $username
echo "$username deleted sucessfully"
}

# show user details
userdetails() {
read -p "Please enter username: " username
chage -l $username
}

# list users
listusers() {
echo "list of users:"
cut -d: -f1 /etc/passwd
}

# enable user account
enableuser() {
read -p "Please enter username: " username
sudo usermod -U $username
echo "$username account is enabled"
}

# disable user account
disableuser() {
read -p "Please enter username: " username
sudo usermod -L $username
echo "$username account is disabled"
}


# change user's password
changepassword() {
read -p "Please enter username: " username
sudo passwd $username
echo "$username password changed successfully"
}

# add group
addgroup() {
read -p "Please enter group name: " groupname
sudo groupadd $groupname
echo "$groupname added successfully"
}

# delete group
deletegroup() {
read -p "Please enter group name: " groupname
sudo groupdel $groupname
echo "$groupname deleted successfully"
}

# add user to group
addusergroup() {
read -p "Please enter username you want to add to group: " username
read -p "Please enter groupname: " groupname
if getent group "$groupname" > /dev/null; then
  echo "Group $groupname exists"
  gpasswd  -a $username $groupname
  echo " $username added to $groupname  successfully!"
else
  echo "Group $groupname does not exist, creating one!"
  sudo groupadd $groupname
  gpasswd  -a $username $groupname
  echo " $username added to $groupname successfully!"
fi
}

# delete user from group
deleteusergroup() {
read -p "Please enter username you want to delete from group: " username
read -p "Please enter groupname: " groupname
if getent group "$groupname" > /dev/null; then
  gpasswd -d $username $groupname
  echo "$username removed from goup $groupname"
else
  echo "Group $groupname does not exist. Please try again"
fi
}

# list groups
listgroups() {
cut -d: -f1 /etc/group
}

# Menu
select option in "Add user" "Delete user" "Show user details" "List users" "Enable user's account" "Disable user's account" "Change user's password" "Add group" "Delete group" "Add user to group" "Delete user fromgroup" "List groups" "Exit"
do
case $option in
"Add user")
adduser ;;

"Delete user")
deleteuser;;

"Show user details")
userdetails;;

"List users")
listusers;;

"Enable user's account")
enableuser;;

"Disable user's account")
disableuser;;

"Change user's password")
changepassword;;

"Add group")
addgroup;;

"Delete group")
deletegroup;;

"Add user to group")
addusergroup;;

"Delete user from group")
deleteusergroup;;

"List groups")
listgroups;;

"Exit")
exit ;;

esac

done
