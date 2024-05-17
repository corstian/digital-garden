---
title: "Substituting part of the lift equation with the climbrate"
layout: default
date: 2020-10-05
usemathjax: true
---

# Substituting part of the lift equation with the climbrate
If we want to use the lift equation using only a limited amount of externally observed movements of the aircraft, we'll need to substitute the lift parameter with the observed climbrate instead. Doing this requires decomposing the lift into the various units it is defined by.

Assuming we are deriving this information from timestamped position updates (latitude, longitude, altitude), we should interpolate these points to get information remotely useful.

Assuming the calculation of $\Delta t_i$ and $\Delta s_i$ against previous points.

**Velocity:**
$$v_i = \frac {\Delta s_i} {\Delta t_i}$$

**Change in velocity:**
$$\Delta v_i = -v_{i-1} + v_i$$

**Acceleration:**
$$a_i = \frac {\Delta v_i} {\Delta t_i}$$

## Rewriting the lift equation
There are multiple paths to embed this information into the lift formula. The simplest of all is to take the lift force represented in newtons ($F=m\ a$), replace the lift with the two components $m$ and $a$, and modify the lift equation to the point where we're able to put this information in.

$$
L=Cl\ \frac {r\ V^2} 2 A
$$

Deconstruct lift into mass and acceleration; we are able to compute acceleration based on reported information:

$$
m\ a = Cl\ \frac {r\ V^2} 2 A
$$

The implication of only using the acceleration as a substitution for the climbrate is that we should move the mass over to the other side:

$$
a = Cl\ \frac {r\ V^2} 2 A\ m^{-1}
$$


From this rewritten lift formula it becomes evident that we are missing several crucial pieces of information if we truly want to retrieve the total amount of lift only based on the position information alone. Specifically being the lift coefficient, wing area and aircraft mass.


*See also [Position, Velocity, Acceleration and Jerk](./position-velocity-acceleration-jerk.md) for a handy chart on the differences between these.*