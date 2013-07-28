---
comments: true
date: 2013-07-27 15:00:00
layout: post
slug: fixed-point-single-pole-filter-pt2

title: Fixed Point Filter Implementation
summary: "Fixed Point Math for Digital Filtering"
image: 'fixedpt-digital-filter/dfilt.png'
tags:
- dsp
- fixed-point
---

Many higher end microprocessors do not require fixed point math as they have
in hardware a floating point unit which is quite fast.  However, there are still
many 8 bit, 16 bit, and even 32 bit systems which do not have this luxury and
must take a sizable performance hit to emulate floating point operations in
software.  Rather than make the micro suffer each time the `RESET` line goes
low, we can implement fixed point software that will save untold CPU cycles.

Fixed pointing our math can be tricky business.  Overflows, round off errors,
etc. can cause severe problems.  Simulation is one of the best tools to combat
these problems and prevent the costly cycle of cross compile, on target test,
and on target debug.  If one has [Matlab/Simulink](http://mathworks.com),
simulation comes for free.  If ones pockets are not so deep, like ~$30k for
a basic embedded code generation package *eek!*, we can still compile our
routines for the host machine, in my case Ubuntu Linux.  We can write our
fixed point filter as a function and design it to be built for either an
embedded target or our host machine.

