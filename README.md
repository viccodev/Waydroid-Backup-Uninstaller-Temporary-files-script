# Waydroid Uninstaller & Remove Temporary Files & Data Backup Script
script flow: 
1. Back up files stored in Waydroid's common directories. (Downloads, Pictures, etc.)
2. Stop waydroid and uninstall it.
3. Remove temporary files, configuration, and .desktop files that sometimes remain after uninstalling. (Ej: gnome waydroid icons remaining)
4. Done

# WARNING
This script is designed to back up the data stored on: home/YOUR-USER/.local/share/waydroid/data/media/0/
It only backs up data from:

* Downloads
* Documents 
* Pictures
* Movies
* DCIM
* Music

Data outside of these directories cannot be saved.
this is for obvious reason, If you have downloaded anything important in Waydroid that you don't want to lose, this backup can be helpful. 
If not, simply dont do the backup.

# Why this script?:

In my experience, Waydroid is good, but it can be buggy. Sometimes, reinstalling it is painful because temporary files can interfere with a 
"fresh install" or mix with new data. I'm not sure why this happens.

# Note: 
This script removes ALL Waydroid data and configuration... 
Consider this carefully.

# This script was originally made for Fedora 42
It may work on other distributions, but use it with caution.
I'm not a developer, just a new student.
However, the core commands should work on most distributions.
This script does not remove sensitive user data.

Download: 

