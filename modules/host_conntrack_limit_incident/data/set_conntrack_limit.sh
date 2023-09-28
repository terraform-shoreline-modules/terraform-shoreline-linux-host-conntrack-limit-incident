

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