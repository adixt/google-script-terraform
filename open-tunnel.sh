#!/bin/bash

start=30000
end=45000
increment=500
ssh_username="adam"
ssh_private_key_path="~/.ssh/google-cloud-rsa"
vm_ip="34.118.26.6"

for ((i=start; i<=end; i+=increment))
do
    # Calculate the upper limit olocalf the current range
    upper=$((i+increment-1))
    # Ensure the upper limit does not exceed the end value
    if [ $upper -gt $end ]; then
        upper=$end
    fi

    # Create the SSH port forwarding options
    port_forwarding=$(for ((j=i; j<=upper; j++)); do echo -n "-L $j:localhost:$j "; done)

    # Execute SSH in a new terminal
    gnome-terminal -- ssh $ssh_username@$vm_ip -i $ssh_private_key_path $port_forwarding &
    
    # Break the loop if the upper limit has reached or exceeded the end value
    if [ $upper -ge $end ]; then
        break
    fi
done
