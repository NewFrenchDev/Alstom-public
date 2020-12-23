# How to restart ATS machines?

## First of all, what do each script?

### Launch-Restart-ATS.bat alias THE COMMANDER

Launch-Restart-ATS.bat is a script permiting to literally launch the script Restart-ATS.bat installed on a specific network path.
For example, the project on which I work, have a network named \\OCC_LCM_TCC1\ArchivesFirstShared\ where all the ATS machines have access. So by this way all computer have access to our script Restart-ATS.bat if we put it here : \\OCC_LCM_TCC1\ArchivesFirstShared\Restart-ATS.bat
This script is the button launching the second one operating on all ATS machines simultaneously!

### Restart-ATS.bat alias THE EXECUTER

As you have already understand this one is the one killing processes on each ATS machines simultaneously and restarting them after that.

## Oh you want to see other scripts or projects done by me?!

[<img align="left" alt="GitHub" width="100px" src="https://img.shields.io/badge/github%20-%23121011.svg?&style=for-the-badge&logo=github&logoColor=white"/>](https://github.com/NewFrenchDev) https://github.com/NewFrenchDev/

This script is used on TCC1 or TCC2 (Workstation/VM corresponding to the HMI)

You need also to put the script in the path said in it (script_path).
If you don't want to put in the default path I wrote, you can change it with the path where you want to put it on the network.

IMPORTANT: The path needs to be accessible by all VMs!
