#!/bin/bash

# Write a function called repeatStr which repeats the given string string exactly n times.

# repeatStr(6, "I") // "IIIIII"
# repeatStr(5, "Hello") // "HelloHelloHelloHelloHello"

repeat=$1
string=$2
echo $(printf "%.s$string" $(seq $repeat))