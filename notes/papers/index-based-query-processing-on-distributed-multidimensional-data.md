---
title: "Index-based query processing on distributed multidimensional data"
layout: default
date: 27-01-2024
toc: false
---

# Index-based query processing on distributed multidimensional data
> _Tsatsanifos, George, Dimitris Sacharidis, and Timos Sellis. “Index-Based Query Processing on Distributed Multidimensional Data.” GeoInformatica 17, no. 3 (July 2013): 489–519. [https://doi.org/10.1007/s10707-012-0163-x](https://doi.org/10.1007/s10707-012-0163-x)._

The reason this paper makes the list is because I have been working on an implementation, but have never managed to apply it in practice. At the time I stumbled upon this paper I had to deal with a data store which grew too quickly. Tired of having to manage this storage infrastructure I wanted to find a way where I could:

1. Dynamically add and remove nodes from a cluster based on performance demands
2. Have the ability to run a data store with only a subset of all available data loaded into memory

The fascinating thing is that this paper provides a solution for these problems through the use of a distributed [k-d tree](https://en.wikipedia.org/wiki/K-d_tree) storing the data in its leaves, rather than in the tree structure itself. One main shortcoming emerged over the years, and that is that it is rather difficult or outright impossible - depending on data size - to update the dimensions on which the k-d tree is split up. This immutability is a severe design constraint, limiting the possible applications of this idea.

One area where this idea can potentially be applied is in the scope of distributed graph databases. This is one area I see myself potentially venturing out into some time in the future.

Personally I generally refer to this data structure as "MIDAS"; in reference to the first paper that had been published about this structure back in 2011. It had been an acronym for "_Multi-attribute Indexing for Distributed Architecture Systems_". Although not too much changed between 2011 and 2013, the 2013 article had been easier to read, which is why I'm referring to that one instead.
