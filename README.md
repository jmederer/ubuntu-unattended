# Unattended Ubuntu ISO Maker

This simple script will create an unattended Ubuntu ISO from start to finish. It will ask you a few questions once, and embed your answers into a remastered ISO file for you to use over and over again.

This script creates a 100% original Ubuntu installation; the only additional software added is ```openssh-server```. There is no ```apt-get update``` performed. You have all the freedom in the world to customize your Ubuntu installation whichever way you see fit. This script just takes the pain out of re-installing Ubuntu over and over again.

Created by: **Harald van der Laan**

## Compatibility

The script supports the following Ubuntu editions out of the box:

* Ubuntu 14.04.3 Server LTS i386  - Trusty Tahr
* Ubuntu 14.04.3 Server LTS amd64 - Trusty Tahr
* Ubuntu 15.10 Server i386        - Wily Werewolf
* Ubuntu 15.10 Server amd64       - Wily Werewolf

This script has been tested on and with these two versions as well, but I see no reason why it shouldn't work with other Ubuntu editions. Other editions would require minor changes to the script though.

## Usage

* From your command line, run the following commands:

```
$ git clione https://github.com/hvanderlaan/ubuntu-unattened
$ sudo ./create-unattended-iso.sh
```
or
```
$ wget https://raw.githubusercontent.com/hvanderlaan/ubuntu-unattended/master/create-unattended-iso.sh
$ chmod 0744 create-unattended-iso.sh
$ sudo ./create-unattended-iso.sh
```

* Choose which version you would like to remaster:

```
 +---------------------------------------------------+
 |            UNATTENDED UBUNTU ISO MAKER            |
 +---------------------------------------------------+

 which ubuntu edition would you like to remaster:

  [1] Ubuntu 14.04.3 LTS Server i386  - Trusty Tahr
  [2] Ubuntu 14.04.3 LTS Server amd64 - Trusty Tahr
  [3] Ubuntu 15.10 Server i386  - Wily Werewolf
  [4] Ubuntu 15.10 Server amd64 - Wily Werewolf

 please enter your preference: [1|2|3|4]:
```

* Enter your desired timezone; the default is *Europe/Amsterdam*:

```
 please enter your preferred timezone: Europe/Amsterdam
```

* Enter your desired username; the default is *haraldvdlaan*:

```
 please enter your preferred username: haraldvdlaan
```

* Enter the password for your user account; the default is *empty*

```
 please enter your preferred password:
```

* Confirm your password:

```
 confirm your preferred password:
```

* Sit back and relax, while the script does the rest! :)

## What it does

This script does a bunch of stuff, here's the quick walk-through:

* It asks you for your preferences regarding the unattended ISO
* Downloads the appropriate Ubuntu original ISO straight from the Ubuntu servers; if a file with the exact name exists, it will use that instead (so it won't download it more than once if you are creating several unattended ISO's with different defaults)
* Downloads the netson preseed file; this file contains all the magic answers to auto-install ubuntu. It uses the following defaults for you (only showing most important, for details, simply check the seed file in this repository):
 * Language/locale: en_US
 * Keyboard layout: US International
 * Root login disabled (so make sure you write down your default usernames' password!)
 * Partitioning: LVM, full disk, single partition
* Install the mkpasswd program (part of the whois package) to generate a hashed version of your password
* Install the genisoimage program to generate the new ISO file
* Mount the downloaded ISO image to a temporary folder
* Copy the contents of the original ISO to a working directory
* Set the default installer language
* Add/update the preseed file
* Add the autoinstall option to the installation menu
* Generate the new ISO file
* Cleanup
* Show a summary of what happended:

```  
 installing required packages
 remastering your iso file
 creating the remastered iso
 -----
 finished remastering your ubuntu iso file
 the new file is located at: /tmp/ubuntu-14.04.3-server-amd64-unattended.iso
 your username is: haraldvdlaan
 your password is: 
 your hostname is: ubuntu
 your timezone is: Europe/Amsterdam
```

### Once Ubuntu is installed ...

Just fire off the init.sh script in your user's home directory to complete the installation. 

```$ sudo ~/init.sh``` 
