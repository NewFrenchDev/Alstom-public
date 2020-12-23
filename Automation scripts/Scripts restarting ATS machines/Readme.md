# How to restart ATS machines

## First of all, what do each script?

### 1. Launch-Restart-ATS.bat alias THE COMMANDER 🚀

Launch-Restart-ATS.bat is a script permiting to literally launch the script Restart-ATS.bat installed on a specific network path.  
For example, the project on which I work, have a network named \\OCC_LCM_TCC1\ArchivesFirstShared\ where all the ATS machines have access. By this way, all computer have access to our script Restart-ATS.bat if we put it here : \\OCC_LCM_TCC1\ArchivesFirstShared\Restart-ATS.bat  
This script is the button launching the second one operating on all ATS machines simultaneously!

### 2. Restart-ATS.bat alias THE EXECUTER 🛠️

As you have already understood this one is the one killing processes on each ATS machines simultaneously and restarting them after that.

## What the difference between Cloud and physical platform?

The access to the script Restart-ATS.bat!  
Physical platforms have a direct access to an extern disk so we will get directly the disk access easily. On cloud platform it's so easy and it can take some times before that the disk is recognized by the Virtual machine. So we it's more simple and faster to have directly access to a shared folder 😉

## Now you want to use another path? 🤓

Simple, if you open each xml files in the folder "Files to put on HMI", you will see at the bottom a line with tag named <Command>Script_path\script_name.extension</Command>. Put the path where you want to put your script but don't forget that all ATS machines that you want to restart need to have access to the same folder!!

## What? Why did I use XML files instead of using only the command schtasks?

Because it's not enough for this task! Don't worry I am going to tell you why.  
Even if you can ran the script by distance each programm needs to have a priority sets correctly depending to the action made by the script executed.  
When you want to simply doing copy from one folder to another there no need for this. Buuuut, if you want to launch another programm which need to establish a connection between machines you have to increase the priority level of the script. Otherwise, the programm launch by your script won't work very well and you will see a leak of memory on the process in charge of a specific connection.
By default all schedule task created by schtasks are at level 7 which is too low (Below Normal).   
That's why I put the priority level to 2 (Above Normal) and yes the only way to do that is with a XML file.

## Oh, you found this outside of my GitHub and you want to see my other scripts and projects?! 😏

[<img align="left" alt="GitHub" width="100px" src="https://img.shields.io/badge/github%20-%23121011.svg?&style=for-the-badge&logo=github&logoColor=white"/>](https://github.com/NewFrenchDev) https://github.com/NewFrenchDev/
