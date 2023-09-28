
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Host conntrack limit incident
---

A host conntrack limit incident occurs when the number of conntrack is approaching the limit of a particular host. This can cause network connectivity issues and can potentially affect the performance of the host. The incident may need to be investigated and resolved by a software engineer or network administrator.

### Parameters
```shell
export IP_ADDRESS="PLACEHOLDER"

export PORT_NUMBER="PLACEHOLDER"

export PROTOCOL_NAME="PLACEHOLDER"

export INTERFACE="PLACEHOLDER"

export FILE_NAME="PLACEHOLDER"

export CONNTRACK_THRESHOLD="PLACEHOLDER"

export NEW_LIMIT="PLACEHOLDER"
```

## Debug

### Check the current conntrack limit
```shell
sudo sysctl net.netfilter.nf_conntrack_max
```

### Check the current number of conntracked connections
```shell
sudo cat /proc/sys/net/netfilter/nf_conntrack_count
```

### Check the current number of connections for a specific IP address
```shell
sudo grep ${IP_ADDRESS} /proc/net/nf_conntrack
```

### Check the current number of connections for a specific port
```shell
sudo grep ${PORT_NUMBER} /proc/net/nf_conntrack | wc -l
```

### Check the current number of connections for a specific protocol
```shell
sudo cat /proc/net/nf_conntrack | grep ${PROTOCOL_NAME} | wc -l
```

### Check the list of established connections for a specific IP address
```shell
sudo netstat -nputw | grep ${IP_ADDRESS} | grep ESTABLISHED
```

### Check the list of established connections for a specific port
```shell
sudo netstat -nputw | grep ${PORT_NUMBER} | grep ESTABLISHED
```

### Check the list of listening ports
```shell
sudo netstat -nputw | grep LISTEN
```

### Check the network traffic using tcpdump
```shell
sudo tcpdump -i ${INTERFACE} -nn -s0 -vvv -w ${FILE_NAME}.pcap
```

### Increase in traffic causing the conntrack limit to be reached on the host.
```shell
bash

#!/bin/bash



# Set the threshold for the conntrack limit

CONNTRACK_LIMIT=${CONNTRACK_THRESHOLD}



# Get the current number of conntrack entries

CURRENT_CONNTRACK=$(cat /proc/sys/net/netfilter/nf_conntrack_count)



# Check if the current number of conntrack entries is approaching the limit

if [ $CURRENT_CONNTRACK -gt $((CONNTRACK_LIMIT*0.8)) ]

then

  echo "WARNING: Number of conntrack entries is approaching the limit. Current count: $CURRENT_CONNTRACK"

else

  echo "Conntrack count is within limit. Current count: $CURRENT_CONNTRACK"

fi


```

## Repair

### Increase the conntrack limit on the affected host.
```shell


#!/bin/bash



# Set the new conntrack limit

NEW_LIMIT=${NEW_LIMIT}



# Get the current conntrack limit

CURRENT_LIMIT=$(sysctl net.netfilter.nf_conntrack_max | awk '{print $3}')



# Check if the new limit is greater than the current limit

if [[ $NEW_LIMIT -gt $CURRENT_LIMIT ]]; then

  # Set the new conntrack limit

  sysctl net.netfilter.nf_conntrack_max=$NEW_LIMIT



  # Update the sysctl configuration file to make the change permanent

  echo "net.netfilter.nf_conntrack_max=$NEW_LIMIT" >> /etc/sysctl.conf



  # Reload the sysctl configuration

  sysctl -p

fi


```