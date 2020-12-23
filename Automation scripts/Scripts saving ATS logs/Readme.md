# How to save ATS logs

## First of all, what do each script?

### 1. Launch-autosaving-logs.bat alias THE COMMANDER 🚀

Launch-autosaving-logs.bat is a script permiting to literally launch the script Autosaving-Logs.bat installed on a specific network path or disk.  
For example, the project on which I work, have a network named \\OCC_LCM_TCC1\ArchivesFirstShared\ where all the ATS machines have access. By this way, all computer have access to our script Autosaving-Logs.bat if we put it here : \\OCC_LCM_TCC1\ArchivesFirstShared\Autosaving-Logs.bat  
This script is the button launching the second one operating on all ATS machines listed in it simultaneously!

### 2. Autosaving-Logs.bat alias THE EXECUTER 🛠️

As you have already understood this one is the one saving logs from each ATS machines simultaneously on a specific path indicated in it.

## What the difference between Cloud and physical platform?

The access to the script Autosaving-Logs.bat!  
Physical platforms have a direct access to an extern disk so we will get directly the disk access easily. On cloud platform it's so easy and it can take some times before that the disk is recognized by the Virtual machine. So we it's more simple and faster to have directly access to a shared folder 😉

## Now you want to use another path? 🤓

Simple, if you open the file Launch-autosaving-logs.bat, you will see a variable called "network_script_path". Change this variable with the path you want but be careful to put a space after the "=".  
Put the path where you want to put your script but don't forget that all ATS machines that you want to restart need to have access to the same folder!!


## Oh, you found this outside of my GitHub and you want to see my other scripts and projects?! 😏

[<img align="left" alt="GitHub" width="100px" src="https://img.shields.io/badge/github%20-%23121011.svg?&style=for-the-badge&logo=github&logoColor=white"/>](https://github.com/NewFrenchDev) https://github.com/NewFrenchDev/
