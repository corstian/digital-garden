---
title: "Trees without split points"
slug: "trees-without-split-points"
date: 2024-03-16
toc: false
---

When constructing some sort of (binary) tree structure we ought to have some split point. The split point itself would be the point in between the left and right leaves beneath a node.

Normally when populating a tree, the split points are generated on-demand, based on the number of values contained in a leaf. If this exceeds a certain treshold, a new random value is generated to represent the new split point, or alternatively a median value is taken.

The downside of this approach is that you need to be able to generate a split value, but what if such split value is not numeric, but instead a string, or even a multi-dimensional vector? The problem here is that the generation of new values for anything but a number is not straightforward.

This idea - which sparked out of sheer lazyness - developed further and made me wonder how it would be possible to achieve a splitting method without having the ability to generate these split points themselves.

The straightforward solution to this solely depends on an equality comparison function. One comparable to those seen in JavaScript for sorting items. As long as the entries of a given leaf are ordered according to the equality function, it becomes nearly trivial to pick an item from the middle and use this value as the split point.

One interesting implication of this idea is that a lot of information can be encoded in an equality function. As there (unfortunately) is no upper limit to the complexity of the equality function, it is even possible to chunk up to conditionally use multiple dimensions for determining the equality of two pieces of data. There is an inherent risk to the complexity of such approach, though there is nothing preventing us from doing so.

Last but not least one might wonder why one would willingly increase the complexity of a tree structure by implementing such method. In this case the increased complexity of the splitting method may make it easier to support a wide variety of data types, or even use a different splitting method per field.