---
title: "The algebra of random variables"
slug: "algebra-of-random-variables"
date: 2024-06-03
layout: default
---

> "The **algebra of random variables** in [statistics](https://en.wikipedia.org/wiki/Statistics), provides rules for the [symbolic manipulation](https://en.wikipedia.org/wiki/Symbolic_computation) of [random variables](https://en.wikipedia.org/wiki/Random_variable), while avoiding delving too deeply into the mathematically sophisticated ideas of [probability theory](https://en.wikipedia.org/wiki/Probability_theory). Its symbolism allows the treatment of sums, products, ratios and general functions of random variables, as well as dealing with operations such as finding the [probability distributions](https://en.wikipedia.org/wiki/Probability_distribution) and the [expectations](https://en.wikipedia.org/wiki/Expected_values) (or expected values), [variances](https://en.wikipedia.org/wiki/Variance) and [covariances](https://en.wikipedia.org/wiki/Covariance) of such combinations."
> - https://en.wikipedia.org/wiki/Algebra_of_random_variables

In the above excerpt, it does not matter whether or not the random variable itself is a true random variable, or a perceived random variable. This yields a powerful tool for use in explorative data analysis.

For the symbolic manipulation of random variables one can use the following operations:

- Addition
	$Z=X+Y=Y+X$
- Subtraction
	$Z=X-Y=-Y+X$
- Multiplication
	$Z=XY=YX$
- Division
	$Z=\frac X Y =X\cdot \frac 1 Y=\frac 1 Y \cdot X$
- Exponentiation
	$Z=X^Y=e^{Y\ ln(X)}$

These operations are equal the elementary algebraic operations. The key however is that when applied on a set, the probability distribution of the resulting set is distinct from the probability distributions of the input data.

These distinct probability distributions are also where the power of this concept comes from. One handy application in explorative data analysis is to map out different observed properties of the system against one another. At times it happens that out of the noise, a pattern emerges.

While correlation does not imply causation, this might contain at least some predictive power, and push you into the right direction for understanding the dynamics of the complex system you're working with.
