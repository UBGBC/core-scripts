from __future__ import print_function
import sys

file = open(sys.argv[1])
count = 0
for line in file:
	line = line.rstrip()
	if count == 0:
		print(line)
		print('Sample\tReads Processed\tReads with at least one reported alignment\tPercentage\tReads that failed to align\tPercentage\tReads with alignments suppressed due to -m\tPercentage\tTotal Alignments')
	elif count%6==1:
		print(line,end = '\t')
	elif count%6==2:
		newline = line.split(':')
		print(newline[1],end ='\t')
	elif count%6==3:
		newline = line.split(':')
		newline = newline[1].split(' ')
		print(newline[1],end = '\t')
		print(newline[2].strip(" "),end = '\t')
	elif count%6==4:
		newline = line.split(':')
		newline = newline[1].split(' ')
		print(newline[1],end = '\t')
		print(newline[2].strip(" "),end = '\t')
	elif count%6==5:
		newline = line.split(':')
		newline = newline[1].split(' ')
		print(newline [1],end = '\t')
		print(newline [2].strip(" "),end = '\t')
	elif count%6==0:
		newline = line.split(' ')
		print(newline[1])
	count +=1





