#!/bin/bash

log_file="access.log"
all_ip=()
all_endpoints=()
if [[ -e "$log_file" ]]; then
	mapfile lines <"$log_file"
	for line in "${lines[@]}";do
		all_ip+=("$(echo "$line" | cut -d " " -f1)")
		all_endpoints+=($(echo "$line" | cut -d '"' -f2 | cut -d " " -f2))
	done
#extract all unique ips
	declare -A unique_ips
	if (( ${#all_ip[@]} > 0 )); then
		for ip in "${all_ip[@]}"; do
			if [[ ! -v  unique_ips["$ip"] ]]; then
				unique_ips["$ip"]=1
                        else
                                (( unique_ips["$ip"]++ ))
                        fi

		done
	fi
	if (( ${#unique_ips[@]} > 0 )); then
		most_req=0
		ip=""
		echo "total uniqe IPs : ${#unique_ips[@]}"
		for key in "${!unique_ips[@]}";do
			if (( $most_req != 0 && ${unique_ips[$key]} > $most_req ));then
				most_req="${unique_ips[$key]}"
				ip="$key" 
			fi
                        if (( $most_req == 0 ));then
                                most_req="${unique_ips[$key]}"
                                ip="$key"
                        fi

			echo "$key appeared ${unique_ips[$key]} times"
		done
		echo "$ip made most requests : $most_req times"
	fi

	#extract endpointss

	declare -A unique_endpoint
        if (( ${#all_endpoints[@]} > 0 )); then
                for route in "${all_endpoints[@]}"; do
                        if [[ ! -v  unique_endpoint["$route"] ]]; then
                                unique_endpoint["$route"]=1
                        else
                                (( unique_endpoint["$route"]++ ))
                     	fi
                done
		echo "End points in ascending order :"
		for key in "${!unique_endpoint[@]}"; do
    			echo "${unique_endpoint[$key]} $key"
		done | sort -n | while read -r count endpoint; do
			echo "$endpoint appeared $count times"
		done

        fi

fi

