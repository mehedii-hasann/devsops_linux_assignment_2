#!/bin/bash
book_file="book.txt"
processed_array=()
if [[ -e "$book_file" ]]; then
	mapfile -t lines<"$book_file"
	echo "To lowercase and all punctuation removed :"
	echo "----------------------------------------"
	for line in "${lines[@]}"; do
		temp=$(echo "$line" | tr -d '[:punct:]' | tr 'A-Z' 'a-z')
		echo "$temp"
		processed_array+=("$temp")
	done
	echo "----------------------------------------"

	declare -A unique_words

	for line in "${processed_array[@]}"; do
		read -a words <<< "$line"
		for word in "${words[@]}"; do
			if [[ -n "$word" ]]; then
				if [[ ! -v unique_words["$word"] ]]; then
					unique_words["$word"]=1
				else
					(( unique_words["$word"]++ ))
				fi
			fi
		done
	done

	echo "frequency of each unique word : "
        for key in "${!unique_words[@]}"; do
                echo "$key : ${unique_words[$key]}"
        done 

	echo "--------------------------------------------------------------------------------"

	echo "top 10 most frequently used words with the number of times they have appeared : "
	count=0
	for key in "${!unique_words[@]}"; do
		echo "${unique_words[$key]} $key"
	done | sort -nr | while read -r val key; do
				if (( $count == 10 )); then
					break;
				fi
				(( count++ ))
				echo "$key : $val times"
			done

	echo "----------------------------------------------------"
	echo "words in each sentence :"
	ten_words_sentence=()
	total_words=0
	for key in "${!processed_array[@]}"; do
		read -a words <<< "${processed_array[$key]}"
		(( total_words += ${#words[@]} ))
		if (( ${#words[@]} > 10 )); then
			ten_words_sentence+=("${words[*]}")
		fi
		temp=$(( key+1 ))
		echo "sentence $temp : ${#words[@]} words"
	done
	echo "-----------------------------------------------------"
	echo "sentences that have more than 10 words : "
	for line in "${ten_words_sentence[@]}"; do
		echo "$line"
	done

	echo "----------------------------------------------------"
	avg=$(( total_words/${#processed_array[@]} ))
	echo "average number of words per sentence : $avg"
fi
