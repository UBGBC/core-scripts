from __future__ import print_function
import sys

file = open(sys.argv[1])
count = 0
for line in file:
	line = line.rstrip()
	if count == 0:
		print(line)
		print('Sample\tReads\tUnpaired Reads\tPercentage\tReads that failed to align\tPercentage\tReads aligned 1 time\tPercentage\tReads Aligned Multiple Times\tPercentage\tPercent Overall Alignment')
	elif count%7==1:
		print(line,end = '\t')
	elif count%7==2:
		newline = line.split(' ')
		print(newline[0],end ='\t')
	elif count%7==3:
		newline = line.split('(')
		unpaired = newline[0].strip(' ')
		newline = newline[1].split('%')
		print(unpaired,end = '\t')
		print(newline[0],end = '\t')
	elif count%7==4:
		newline = line.split('(')
		unpaired = newline[0].strip(' ')
		newline = newline[1].split('%')
		print(unpaired,end = '\t')
		print(newline[0],end = '\t')
	elif count%7==5:
		newline = line.split('(')
		unpaired = newline[0].strip(' ')
		newline = newline[1].split('%')
		print(unpaired,end = '\t')
		print(newline[0],end = '\t')
	elif count%7==6:
		newline = line.split('(')
		unpaired = newline[0].strip(' ')
		newline = newline[1].split('%')
		print(unpaired,end = '\t')
		print(newline[0],end = '\t')
	elif count%7==0:
		newline = line.split('%')
		print(newline[0])
	count +=1




