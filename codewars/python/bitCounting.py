'''
Write a function that takes an integer as input, and returns the number of bits that are equal to one in the binary representation of that number. You can guarantee that input is non-negative.

Example: The binary representation of 1234 is 10011010010, so the function should return 5 in this case
'''

def count_bits(n):
    return len([x for x in bin(n) if x == '1'])

# Using count method
def count_bits2(n):
    return bin(n).count('1')