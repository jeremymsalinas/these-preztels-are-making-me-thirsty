'''
Complete the solution so that it splits the string into pairs of two characters. If the string contains an odd number of characters then it should replace the missing second character of the final pair with an underscore ('_').

Examples:

* 'abc' =>  ['ab', 'c_']
* 'abcdef' => ['ab', 'cd', 'ef']
'''

def solution(s):
    return [s[c:c+2] if c < len(s) - 1 else s[-1] + '_' for c in range(0, len(s), 2)]