---
title: "Binary tree splitting"
layout: default
date: 2025-11-5
toc: false
---

[Binary trees](https://en.wikipedia.org/wiki/Binary_tree) are data structures which can be used to efficiently look up data. Binary trees, and derived data structures such as the [binary search tree](https://en.wikipedia.org/wiki/Binary_search_tree) and [k-d tree](https://en.wikipedia.org/wiki/K-d_tree), generally have a lookup speed of O(log n) when perfectly balanced.

Binary trees work by having a split value defined on each node indicating where next to go. This split value, while often numeric, can be a bitarray as well. While treating a numeric value as a bitarray works, treating a bitarray as a numeric value is often a bad idea.

## Numeric splits
Conceptually a numeric split works like this:

```csharp
public int Lookup(int value) {
    var splitValue = 5;

    if (value >= splitValue) return 1; // go to right node
    else return -1; // go to left node
}
```

Expressed in binary these are the contents of the leaves:
```
Left leaf:      Right leaf:
0: 0000         5: 0101
1: 0001         6: 0110
2: 0010         7: 0111
3: 0011         8: 1000
4: 0100         ...
```

These are neatly organized.

## Bit splits
As an alternative approach we can however treat the binary data as binary and use individual bit positions to make the split. A rudimentary split is `x mod 2`, which would result in all odd numbers being collected in the right split.

Doing so would create the following leaves:
```
Left leaf:      Right leaf:
0: 0000         1: 0001
2: 0010         3: 0011
4: 0100         5: 0101
6: 0110         7: 0111
```

Notice here that the least significant bit is what sets the leaves apart from one another. All elements where the least significant bit is unset go left; all others go right. While this creates duplicate splits for all other positions, this still makes up for incredibly efficient search as it becomes immediately clear in what portion of a tree a given value exists. In practice this is useful for indexing documents using [bloom filters](https://en.wikipedia.org/wiki/Bloom_filter) given these are explicitly represented as a bitarray rather than a numeric value.

> Using bit arrays to create splits is not without drawbacks. A significant one is that nearby (numeric) values are no longer closely grouped within the tree itself, making nearest neighbour search a pain. 

This approach is somewhat related to [the Fenwick tree](https://en.wikipedia.org/wiki/Fenwick_tree).