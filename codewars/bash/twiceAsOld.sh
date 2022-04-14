#!/bin/sh

# Your function takes two arguments:

# current father's age (years)
# current age of his son (years)
# Сalculate how many years ago the father was twice as old as his son (or in how many years he will be twice as old).

dad_years_old=$1
son_years_old=$2
let doubleAge=$(( $son_years_old * 2 ))

if [ $dad_years_old -gt $doubleAge ]
then
expr $dad_years_old - $doubleAge
else 
expr $doubleAge - $dad_years_old
fi

exit