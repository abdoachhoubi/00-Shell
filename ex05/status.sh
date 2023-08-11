#!/bin/bash

if [ $1 == "-h" -o $1 == "--help" -o $1 == "help" ]; then
	echo -e "Usage: $0 [filename]"
	echo -e "If filename is provided, the system status report will be saved to that file."
	echo -e "If no filename is provided, the system status report will be displayed on the terminal."
	exit 0
fi

# Get system information
kernel_version=$(uname -r)
os_version=$(sw_vers -productVersion)
hostname=$(hostname)
uptime=$(uptime)

# Get CPU information
cpu_info=$(sysctl -n machdep.cpu.brand_string)
cpu_cores=$(sysctl -n machdep.cpu.core_count)
cpu_threads=$(sysctl -n machdep.cpu.thread_count)

# Get memory information
memory_info=$(sysctl -n hw.memsize)
memory_info=$((memory_info / 1024 / 1024)) # Convert to MB

# Get disk usage
disk_usage=$(df -h /)

# Get network information
ip_address=$(ipconfig getifaddr en0)
gateway=$(netstat -nr | grep default | awk '{print $2}')
dns_servers=$(scutil --dns | grep "nameserver\[[0-9]\]" | awk '{print $3}')

FILE="NULL"

# Display the system status report
if [ $1 ]; then
	if [ -f $1 ]; then
		echo -n "File $1 already exists. Overwrite? (y/n): "
		read overwrite
		if [ overwrite -eq y ]; then
			FILE=$1
		else
			echo "File not overwritten."
		fi
	else
		FILE=$1
	fi
fi

if [ $FILE == "NULL" ]; then
	clear
echo -e "System Status Report for $hostname\n\
----------------------------------------\n\
Kernel Version: $kernel_version\n\
OS Version: $os_version\n\
Uptime: $uptime\n\
----------------------------------------\n\
CPU Information:\n\
  CPU: $cpu_info\n\
  Cores: $cpu_cores\n\
  Threads: $cpu_threads\n\
----------------------------------------\n\
Memory: $memory_info MB\n\
----------------------------------------\n\
Disk Usage:\n\
$disk_usage\n\
----------------------------------------\n\
Network Information:\n\
  IP Address: $ip_address\n\
  Gateway: $gateway\n\
  DNS Servers: $dns_servers\n\
----------------------------------------"
	echo -en "\n:"
	stty -echo
	read -n 1 quit_input
	stty echo
	if [[ $quit_input == q || $quit_input == Q ]]; then
		clear
	    exit 0
	fi
else
	echo -e "System Status Report for $hostname\n\
----------------------------------------\n\
Kernel Version: $kernel_version\n\
OS Version: $os_version\n\
Uptime: $uptime\n\
----------------------------------------\n\
CPU Information:\n\
  CPU: $cpu_info\n\
  Cores: $cpu_cores\n\
  Threads: $cpu_threads\n\
----------------------------------------\n\
Memory: $memory_info MB\n\
----------------------------------------\n\
Disk Usage:\n\
$disk_usage\n\
----------------------------------------\n\
Network Information:\n\
  IP Address: $ip_address\n\
  Gateway: $gateway\n\
  DNS Servers: $dns_servers\n\
----------------------------------------" > $FILE
	echo -e "System status report saved to $FILE"
	exit 0
fi

