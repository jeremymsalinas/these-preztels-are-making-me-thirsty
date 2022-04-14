/*
If we write out the digits of "60" as English words we get "sixzero"; the number of letters in "sixzero" is seven. 
The number of letters in "seven" is five. The number of letters in "five" is four. 
The number of letters in "four" is four: we have reached a stable equilibrium.

Note: for integers larger than 9, write out the names of each digit in a single word (instead of the proper name of the number in English). 
For example, write 12 as "onetwo" (instead of twelve), and 999 as "nineninenine" (instead of nine hundred and ninety-nine).

For any integer between 0 and 999, return an array showing the path from that integer to a stable equilibrium:

Examples
numbersOfLetters(60) --> ["sixzero", "seven", "five", "four"]
numbersOfLetters(1) --> ["one", "three", "five", "four"]
*/

function numbersOfLetters(integer) {
    const numberWords = {
        1: 'one',
        2: 'two',
        3: 'three',
        4: 'four',
        5: 'five',
        6: 'six',
        7: 'seven',
        8: 'eight',
        9: 'nine',
        0: 'zero'
    }
    let numArr = [String(integer).split('').map(i => numberWords[i]).join('')]
    let i = numArr.length - 1

    if (numArr[i] === 'four') {
        return numArr
    }

    do {
        if (numberWords[numArr[i].length] === 'four') {
            numArr.push(numberWords[numArr[i].length])
            return numArr
        } else if (numArr[i].length > 9) {
            numArr.push(String(numArr[i].length).split('').map(i => numberWords[i]).join(''))
            i++
        } else {
            numArr.push(numberWords[numArr[i].length])
            i++
        }
    } while (true)
    return numArr
}