---
title: "Space Weighted Similarity (SWS)"
layout: default
date: 2021-07-15
usemathjax: true
---

> Linked to from ["High Performance Spatiotemporal Trajectory Matching"](./index)

The formula to the Space Weighted Similarity is: 

$$
SWS(T_1,T_2)=\frac {\int _α ^β m(p_1(t),\ p_2(t))v_1(t)dt} {\int _{α_1} ^{β_1} v_1(t)dt}
$$

Whereas;
- $m(.,.)$ is the [Point similarity](./point-similarity) function.
- $v_1(t)$ denotes the velocity of $T_1$ at time $t$.

To simplify computation the following approximation can be used:
$$
\int _α ^β m(p_1(t),\ p_2(t))v_1(t)dt \approx \frac {1} {2} \sum _{i=1} ^{n-1} (m_i+m_{i+1})l_i)
$$

Whereas;
- $t_i$ denotes the timestamp after interpolation.
- $m_i$ dnotes the point similarity of two trajectories at timestamp $t_i$.
- $l_i$ denotes the length of line segment of $T_1$ between timestamp $t_i$ and $t_{i+1}$.

The "*space weighted segment score*": $(m_i+m_{i+1})l_i$


> Making sense of the meaning of $v_1(t)dt$ I am turning to dimensionality analysis; the units of which would be $m/s\cdot s$ therefore denoting the distance covered over the course of the set.
> This is in fact backed by the comment within the paper:
> *"... Then divide the result by the duration or total distance of $T_a$ ..."*
> [Time weighted Similarity (TWS)](./time-weighted-similarity)
