# TMC Kiosk Guide

## Disclaimer

*I understand that this document is fairly long. For the sake of time, if you do not wish to read or understand what is outlined in this document, please skip to the `Updating via SSH (Summary of Instructions)` section at the end of the document. Although it is highly recommended to know what you are doing and to understand what you are doing, it is not a requirement.*

## Scope

In this guide I am to explain how to use and maintain the TMC Kiosks, which are running Linux instead of Windows. 

This is targetted for users who do not have experience with Linux, or Ubuntu and need clear instructions on how to use the operating system. 

These Kiosks do not meet the hardware requirements for Windows 11 to be downloaded and installed, and Windows 10 is now no longer recieving security updates. Because of this we have installed [Xubuntu 24.04](https://xubuntu.org/release/24.04/) onto these Kiosks. 

Using and interacting with these Kiosks is very simple, and all of the technical setup has already been completed. Simple maintenence is all that is required unless major changes are needed.

## Terminology

- **`Xubuntu`** (/zʊˈbʊntuː/) is a Canonical-recognized, community-maintained derivative of the Ubuntu operating system. The name Xubuntu is a portmanteau of Xfce and Ubuntu, as it uses the Xfce desktop environment, instead of Ubuntu's customized GNOME desktop. Xubuntu seeks to provide "a light, stable and configurable desktop environment with conservative workflows" using Xfce components. Xubuntu is intended for both new and experienced Linux users. Rather than explicitly targeting low-powered machines, it attempts to provide "extra responsiveness and speed" on existing hardware.
- **`SSH`** (Secure Shell Protocol) is a cryptographic network protocol for operating network services securely over an unsecured network. Its most notable applications are remote login and command-line execution.
- **`Powershell`** is a shell program developed by Microsoft for task automation and configuration management. As is typical for a shell, it provides a command-line interpreter for interactive use and a script interpreter for automation via a language defined for it. Originally only for Windows, known as Windows PowerShell, it was made open-source and cross-platform on August 18, 2016, with the introduction of PowerShell Core. The former is built on the .NET Framework and the latter on .NET (previously .NET Core). 
- **`sudo`** (/suːduː/ or /ˈsuːdoʊ/) is a shell command on Unix-like operating systems that enables a user to run a program with the security privileges of another user, by default the superuser. It originally stood for "superuser do", as that was all it did, and this remains its most common usage; however, the official Sudo project page lists it as "su 'do'". The current Linux manual pages define su as "substitute user", making the modern meaning of sudo "substitute user, do", because sudo can run a command as other users as well.
- **`Chromium`** is a free and open-source web browser project, primarily developed and maintained by Google. It is a widely used codebase, providing the vast majority of code for Google Chrome and many other browsers, including Microsoft Edge, Opera, Vivaldi, Brave, Samsung Browser and Ungoogled Chromium. The code is also used by several app frameworks. 

## Powering On

In order to turn these Kiosks on, you must 

1) Release the two locks found on the *right* side of the machines
2) Open the door
3) Press the circle shaped power button on the side of the machine, towards the top. The button should light up blue once pressed. *(If nothing happens, please ensure the power is switched on at the wall.)*

Once the machine is turned on, the Kiosk should
1) Turn on
2) Open The Metal Company website in full screen mode

## Connecting to the Kiosks

We are able to connect to these Kiosks remotely through `SSH`. Keep in mind, that this way of connecting does not let you see what is happening on screen. This is strictly back-door access to the Kiosks. It allows for control of the Kiosks via the Terminal.

My recommendation for updating the Kiosks is by connecting through `SSH` as I will cover in the next section *"Updating via SSH"*.

In order to connect to the Kiosks through `SSH`, open `Powershell` on your computer and type in the following: 
`ssh tmc@tmc-kiosk-1` *or*
`ssh tmc@tmc-kiosk-2` *(depending on which Kiosk you wish to connect to)*

For visual reference, `tmc-kiosk-1` is on the `RIGHT` and `tmc-kiosk-2` is on the `LEFT`

Once you have entered the first command, you should be prompted to enter a password. 
Please reach out to [caleb.griffiths@themetalcompany.co.nz](mailto:caleb.griffiths@themetalcompany.co.nz) for the password if you do not have it.

Your prompt should now be `tmc@tmc-kiosk-1:~$` or `tmc@tmc-kiosk-2:~$` which means you are now connected to the Kiosk. 

## Updating via SSH

Assuming that you are connected to a Kiosk using the instructions above, you should be able to run commands and control the Kiosk with Terminal commands. 

I have created what is called an `alias` which you can type in the Terminal to run multiple commands/actions with only one command. The alias is as follows: 
**`updatekiosk`**

What this alias does is runs the following commands in sequence:

- `sudo apt update` = refreshes your system's local list of available packages by contacting the repositories in your sources list and downloading the latest package metadata (versions, dependencies). It doesn't install or upgrade anything itself, it just updates the catalogue so apt knows what's available when you next run an upgrade.
- `sudo apt upgrade -y` = installs the newest available versions of all packages currently on your system, based on the catalogue from your last apt update. The -y automatically answers "yes" to the confirmation prompt, so it proceeds without pausing to ask you.
- `pkill -f chromium` = terminates every running process whose full command line contains "chromium", the -f matches against the entire command (including the file path) rather than just the process name.
- `sudo snap refresh chromium` = updates the Chromium snap to the latest revision available in its channel, downloading and installing the new version if one exists. If Chromium is already current, it does nothing and tells you there are no updates available.

As mentioned above, the alias is `updatekiosk`. 
Type `updatekiosk` in the terminal, and it will run each of those above commands in sequence. 

Once complete, it is best practice to run a restart on the Kiosks. 

While still connected via SSH, type
`sudo reboot`

This will immediately restart the Kiosks and will disconnect you from the SSH connection. As mentioned in the Scope, the Kiosk will turn back on and will load The Metal Company's website in full screen. 

### Updating via SSH (Summary of Instructions)

1) Open `Powershell` on your computer (not the Kiosk)
2) Type `ssh tmc@tmc-kiosk-1` or `ssh tmc@tmc-kiosk-2`
3) Enter the password
4) Once connected, type `updatekiosk`
5) Wait for the update to complete
6) Once complete, type `sudo reboot`

##
> Author: Caleb Griffiths
>
> Date: 30/06/2026
>
> For: The Metal Company
>
> Version: 1.0