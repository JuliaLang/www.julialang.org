#!/usr/bin/env python

##************************************##
##**       Name:pick out cn         **##
##**       Author:Gotaly            **##
##** gotawork SHIFT2 google's mail  **##
##** 	  version: 0.1              **##
##**    last update 2012.03.11      **##
##************************************##

import sys

rFileName = sys.argv[1]
wFileName = sys.argv[2]

rf = open(rFileName,'r')
wf = open(wFileName,'w')

IN = False
while True:
    line = rf.readline()
    if not line:
        break
    if '<cn>' in line:
        IN = True
	continue
    if '</cn>' in line:
        IN = False
	continue
    if IN == True:
        wf.write(line)

rf.close()
wf.close()

