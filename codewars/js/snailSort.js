/*
Snail Sort
Given an n x n array, return the array elements arranged from outermost elements to the middle element, traveling clockwise.

array = [[1,2,3],
         [4,5,6],
         [7,8,9]]
snail(array) #=> [1,2,3,6,9,8,7,4,5]
*/

const snail = function(array) {
    // enjoy
    const sorted = []
    while (array.length) {
        sorted.push(...array.shift())
        for (let i = 0; i < array.length; i++) {
            sorted.push(array[i].pop())
        }
        sorted.push(...(array.pop() || []).reverse())
        for (let i = array.length - 1; i >= 0; i--) {
            sorted.push(array[i].shift())
        }
    }
    return sorted
}