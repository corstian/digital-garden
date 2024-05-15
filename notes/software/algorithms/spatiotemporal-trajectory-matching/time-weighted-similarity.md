---
title: "Time Weighted Similarity (TWS)"
layout: default
date: 2021-07-15
usemathjax: true
---

> Linked to from ["High Performance Spatiotemporal Trajectory Matching"](./index)

# Time Weighted Similarity (TWS)

The formula for the Time Weighted Similarity is given as follows:

$$
TWS(T_1,T_2)=\frac {\int _α ^β m(p_1(t),\ p_2(t))dt} {β_1-α_1}
$$

Whereas:
- $m(.,.)$ is the [Point similarity](./point-similarity) function.
- $β_1-α_1$ is the duration of the trajectory

For computational purposes, the following approximation can be used;

$$
\int _α ^β m(p_1(t),\ p_2(t))dt \approx \frac {1} {2} \sum _{i=1} ^{n-1} (m_i + m_{i+1})(t_{i+1}-t_i)
$$

Whereas;
- $t_i$ denotes the timestamp after interpolation.
- $m_i$ dnotes the point similarity of two trajectories at timestamp $t_i$.

The "*time weighted segment score*": $(m_i+m_{i+1})(t_{i+1-t_i})$
