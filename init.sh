#!/bin/bash
set -e

spinner()
{
	local pid=$1
	local delay=0.175
	local spinstr='|/-\'
	local infotext=$2
	tput civis;

	while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
		local temp=${spinstr#?}
		printf " [%c] %s" "$spinstr" "$infotext"
		local spinstr=$temp${spinstr%"$temp"}
		sleep $delay
		printf "\b\b\b\b\b\b"

		for i in $(seq 1 ${#infotext}); do
			printf "\b"
		done
	
	done

	printf " \b\b\b\b"
	tput cnorm;
}

# set defaults
default_hostname="$(hostname)"
default_domain="local"
tmp=$(pwd)

clear

# check for root privilege
if [ "$(id -u)" != "0" ]; then
	echo " this script must be run as root" 1>&2
	echo
	exit 1
fi

# determine ubuntu version
ubuntu_version=$(lsb_release -cs)

# check for interactive shell
if ! grep -q "noninteractive" /proc/cmdline ; then
	stty sane

	# ask questions
	read -ep " please enter your preferred hostname: " -i "$default_hostname" hostname
	read -ep " please enter your preferred domain: " -i "$default_domain" domain
	read -ep " please enter your username: " -i "haraldvdlaan" username
fi

# print status message
echo " preparing your server; this may take a few minutes ..."

# set fqdn
fqdn="$hostname.$domain"

# update hostname
echo "$hostname" > /etc/hostname
sed -i "s@ubuntu.ubuntu@$fqdn@g" /etc/hosts
sed -i "s@ubuntu@$hostname@g" /etc/hosts
hostname "$hostname"

# update repos
(apt-get -y update > /dev/null 2>&1) & spinner $! "updating apt repository ..."
echo
(apt-get -y upgrade > /dev/null 2>&1) & spinner $! "upgrade ubuntu os ..."
echo
(apt-get -y dist-upgrade > /dev/null 2>&1) & spinner $! "dist-upgrade ubuntu os ..."
echo
(apt-get -y install openssh-server zsh git curl vim npm > /dev/null 2>&1) & spinner $! "installing extra software ..."
echo
(apt-get -y autoremove > /dev/null 2>&1) & spinner $! "removing old kernels and packages ..."
echo
(apt-get -y purge > /dev/null 2>&1) & spinner $! "purging removed packages ..."
echo

## fix for installing keybase nodejs uses /usr/bin/nodejs but keybase will use /usr/bin/node
ln -s /usr/bin/nodejs /usr/bin/node

(npm install -g keybase-installer &> /dev/null) & spinner $! "downloading keybase ..."
echo
(keybase-installer &> /dev/null) & spinner $! "installing keybase ..."
echo


# changing bash to zsh
wget -O /home/$username/.zaliasses 'https://raw.githubusercontent.com/hvanderlaan/zsh/master/.zaliasses' > /dev/null 2>&1
wget -O /home/$username/.zfunctions 'https://raw.githubusercontent.com/hvanderlaan/zsh/master/.zfunctions' > /dev/null 2>&1
wget -O /home/$username/.zcolors 'https://raw.githubusercontent.com/hvanderlaan/zsh/master/.zcolors' > /dev/null 2>&1
wget -O /home/$username/.zcompdump 'https://raw.githubusercontent.com/hvanderlaan/zsh/master/.zcompdump' > /dev/null 2>&1
wget -O /home/$username/.zprompt 'https://raw.githubusercontent.com/hvanderlaan/zsh/master/.zprompt' > /dev/null 2>&1
wget -O /home/$username/.zshrc 'https://raw.githubusercontent.com/hvanderlaan/zsh/master/.zshrc' > /dev/null 2>&1
usermod -s /usr/bin/zsh $username
chown $username:$username .z*

# remove myself to prevent any unintended changes at a later stage
rm $0

# finish
echo " DONE; rebooting ... "

# reboot
shutdown -r now
