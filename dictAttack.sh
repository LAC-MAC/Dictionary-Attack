#!/bin/bash

#Produce out.txt by filtering words.txt so that only words less than 16 characters are accepted
grep -vE '^.{15,}$' words.txt > out.txt

#create a variable for the file out.txt that will be looped through
filename='out.txt'

#counter for how many attempts made
n=0

#loop for how many lines in files (i.e how many possible passwords)
while read line; do

    #Loop 10 times (for each digit 0-9)
    for value in {0..9}
    do
        #increment attempt counter
        n=$[n + 1]

        #create variable c for possible password by concat line (password from file) and value (current loop index)
        c="${line}${value}"
        
        #run openssl command for aes-128-cbc using ciphertext that corresponds to me using no salt
        # a message digest method of SHA256, pass the possible password, write output to file to testresult.txt
        #ignore any warnings 
        openssl enc -aes-128-cbc -d -in cipher-task3-40 -out testresult.txt -nosalt -md sha256  -k $c 2>/dev/null
        #chech the output file for the know plaintext phrase
        if grep -Fwq "The secret word is:" testresult.txt; then 
            #write the correct password to pass.txt file
            echo "$c" > pass.txt
            #break all loops
            break 2
        fi

    done

done < $filename


pass=`cat pass.txt`
plain=`cat testresult.txt`
#Print the results in a readable format
echo "Successful Password: $pass"
echo "Number of attempts: $n"
echo "Result of Decryption: $plain"

