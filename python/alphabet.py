#!/usr/local/bin/python
import sys
ALPHABET = ' abcdefghijklmnopqrstuvwxyz'
#if len(sys.argv) == 0:
num = input('Which letter of the alphabet? (1..26) > ')
realnum = int(num)
print(f'Number {num} of the alphabet is ... ',end='')
print(ALPHABET[realnum])
#else:
#    args = str(sys.argv)
#    num_args= len(sys.argv)
#    for num in range(num_args):
#        realnum = int(args[{num}])
#        print(ALPHABET[realnum])
