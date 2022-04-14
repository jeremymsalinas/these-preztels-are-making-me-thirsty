/*
We need to sum big numbers and we require your help.

Write a function that returns the sum of two numbers. The input numbers are strings and the function must return a string.

Example
add("123", "321"); -> "444"
add("11", "99");   -> "110"
*/

function add(a, b) {
    var result = ''
    var carry = 0
        //split a and b into arrays
    a = a.split('')
    b = b.split('')
        //while a, b, or c exists
    while (a.length || b.length || carry) {
        //double bitwise NOT operator to handle undefined as 0
        carry += ~~a.pop() + ~~b.pop()
            //if carry > 9 append ones place to result
        result = carry % 10 + result
            //Carry the tens place and keep adding if carry > 9
        carry = carry > 9
    }
    return result
}