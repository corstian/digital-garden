---
title: "Calculating the kinetic energy for a glider"
layout: default
date: 2020-10-05
usemathjax: true
---

The formula to calculate the amount of kinetic energy in an object is as follows;

$$Ek = 0.5\cdot m\cdot v^2$$

Whereas;  
`Ek`: Kinetic Energy in Joules  
`m`: mass of the object, in kg  
`v`: The velocity of the object, in m/s

As we're calculating the kinetic mass based on position reports and we do not know the mass of the aircraft, we're butchering the formula such that it becomes $\frac {Ek}{m}=\frac {v^2} {2}$. Right now, the value we would be calculating represents the kinetic energy per kg mass.

The data we're using represents the kinetic energy by two vectors;
1. (Forward) velocity
2. Climbrate

Adding those will result in the total amount of kinetic energy in the aircraft per unit of mass.
