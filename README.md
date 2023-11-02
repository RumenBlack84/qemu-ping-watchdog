# qemu-ping-watchdog
A watchdog like script to ensure a VM remains responsive and kills it on any qemu-ping error. 

The script will log to the specified file and rotate the log file if it becomes larger then 50MB (this value is a variable feel free to alter it to your tastes)

The script will also ignore the error of the configuration file not being present on the system. In my usecase this because I'm using promox HA and my VMs can move around.

Simply just add the script to your system and call it using a cron job at your preferred lenghth of time.
