---
title: "Full text search with bloom filters"
---

My interest in data structures and distributed systems came together in the development of a distributed database. Databases are not all that complicated to reason about -- it's just a matter of putting the right information in the right place -- but something didn't fit right. It was late 2022 and I was onboard the Eurostar traveling back home. Having had a meeting in London where we discussed a new business need which with the current database infrastructure would take at least a week to compute. The eventstore we had wasn't built for the troughput we required. Pondering over ways to wrestle with the current infrastructure my thoughts started to shift over ways I would design a system to enable the required throughput. Massive parallelization and distribution was the answer. From the perspective of a data structure this could work except for one thing; full-text search. Having just exited the tunnel the French and Belgian countrysides passed by at a pace at which one can see the weather systems change. Despite the brute forced will to find a solution, I could not think of a way to make full-text search work performantly on a distributed database.

Now at the time of writing about 4 years later I got familiar with many more tricks to efficiently shape data stores. One of these are bloom filters, which can answer the question about a set possibly containing an element, or the set definitely not having said element. This happened to be the missing puzzle to my effort to make distributed and performant full-text search work. It is in this post that I will describe some of the ideas that go behind it, and the missing pieces to actually make it work.

## Context
Full-text search is a somewhat solved problem. The naive solution is to use an inversed index using n-grams referring to documents containing said n-gram. Such approach proves to have significant drawbacks when using a structure related to a distributed binary tree. When a main feature of such distributed data structure is that only partial knowledge is necessary to interact with it, the centralization that comes with an inversed index is antithetical to the intended functioning.

The inherent distributed nature - while elegant - comes with constraints:

- No component should require full visibility into the data structure to function
- Split values cannot be altered once set
- Split values should evaluate to a boolean value (e.g. value exists in the left leaf or value exists in the right leaf)

## Bloom filters
As mentioned earlier, the bloom filter is a data structure able to answer the question "does this element exist in this set" with a "possibly yes" or a "definitely not". The filter itself consists of a bit array with a certain length. Upon insertion of an element, the element is hashed, and based on this hash one or more bits are set to true. Potential hash collisions lead to a situation where it might look like the bloom filter contains a given element, which in reality is a different one.

It is worth making explicit that bloom filters are inherently lossy. You cannot store the information itself in it. After you confirm with a bloom filter the potential existence of an element, you still have to look up the element. Through the application of these filters you spend a small amount of resources to prevent spending a much bigger amount later on.


### String Indexing
Before diving into the specifics of how we can do full text search let us first consider how we can check whether a single string contains a given query. This process consists of the following steps:

1. Chunk up string in 3-grams
2. Insert 3-grams into bloom filter
3. Check query against bloom filter
4. Upon match - check the query against the actual string

```csharp
// todo: write a test method to demonstrate the principle
```

### The binary tree in an ideal situation
The same method as demonstrated above is to be used in a binary tree, though with the distinction that we're not matching queries against full bloom filters, but against portions of bloom filters. To be able to express the full contents of the bloom filter it is however necessary for the binary tree to be as deep as the length of the bloom filter.

This last part is a rather unconvenient characteristic, as it strongly ties these two together. In a situation where the bloom filter would be much wider than the depth of the tree we would be able to store information in the tree just fine. As to queries however we'd run the risk of having to traverse each and every node in our tree due to split values not represented in the query' bloom filter.

```
Binary tree:

- : split value

                            000-
                           /    \
                 _________/      \_________
                /                          \
            00-0                            00-1
           /    \                          /    \
          /      \                        /      \
         /        \                      /        \
        /          \                    /          \
    0-00            0-10            0-01            0-11
   /    \          /    \          /    \          /    \
  /      \        /      \        /      \        /      \
-000    -100    -010    -110    -001    -101    -011    -111

```

Some examples of querying using the queries' bloom filter against the tree above:

- `1000` would need to traverse all the leaves as to be able to retrieve matches
- `0001` is a query which only needs to traverse through the right subtree from the root
- `0010` is a query which would need to traverse two subtrees to find all relevant results
- `0011` is a query which would need to traverse the right subtree of the right subtree to find results
- `1111` is most easily found traversing directly to the single leaf holding all values

The more specific a query, the easier a given entry is found. Contrary to this; a lesser specific query has more potential matches. The case of `1000` is a rather unfortunate one. Queries for solely this hit would still need to access all leaves as to find results matching with the query. This is merely happenstance; in a real-world scenario the split values would be determined randomly, most likely preventing a situation like this.

### Making an ideal situation
The example given is however an ideal case where the depth of the tree matches the length of the bloom filter. In the real world the changes of the amount of data matching up with a predetermined length of the bloom filter would be rather small, and even if it did it would only be a temporary situation.

When the bloom filter relative to the trees' depth is small, query specificity is low. When the opposite is the case - the bloom filter is wider than the trees' depth - query specifity may also suffer. The ideal case remains a bloom width equal to the tree depth; more or less.

An [extensible bloom filter (EBF)](https://ieeexplore.ieee.org/document/10678800) might help in this situation. This variation essentially consists of multiple bloom filters appended to one another.





---

It is necessary for a balance to be struck between the length of the bloom filter, the number of insertions into the bloom filter per document, and the depth of the tree structure holding the bloom filter. On a high level the more important relationship is between the number of insertions per document and the depth of the tree. Are the number of documents too low to properly group them together we're running into the issue that we're unable to properly query through these documents. To a certain extent this can be dealt with by using smaller bloom filters. That is; unless they become too small for the number of insertions per document. At that point with a proper has function the changes that all bits are set approaches 1. While 8 bits can hold 2^8 different combinations, a bloom filter does not work like this. Instead the bloom filter can just hold 8 different entries, not considering hash collisions. There are a number of ways we can partially deal with these characteristics:

- Increase the number of hash functions used for each item inserted in the bloom filter
- Increase the number of nodes in the tree to an appropriate amount
- Use as big of a query as possible

Last but not least there is a very practical problem as to the scaling of bloom filters. In no real-world scenario are we going to store more than a trillion elements in a tree. For this reason the depth of the tree itself will - on average - most likely be no more than 64. Surely enough specific subtrees may as well be deeper; but those are the exception rather than the rule.


One way to tweak the bloom filter is to increase the number of bits set per inserted element. This might reduce the probability of an exact match, but helps matching a given subtree. 



---


While the parameters of the bloom filter are important, the information we'll be inserting for each document may bear more consideration as well. Important are both the maximum number of distinctive elements possible as well as the number of elements likely per document.

There is a remarkable difference between variants of the n-gram: a 2-gram or a digram has $255^2 = 65025$ distinctive elements while a trigram has $255^3=16581375$. 

While 255 is a reasonable choice for ASCII and UTF-8 encoded data we might be tempted to reduce the n-grams to a 128 character set. Though this has negligible impact on storage size, the impact on the solution space for the bloom filter is significant. The distinctive n-grams are respectively reduced to $128^2=16384$ and $128^3=2097152$. If we were to further reduce this set to 26 characters for the alphabet and 10 digits we'd further reduce the solution space to $36^2=1296$ and $36^3=46656$. While these proposals bring forth beneficial improvements in the search space, they also impose rather unfortunate limits on what data can be searched and how. It is for this reason that we might want to focus on the use of the full 8-bit character set and only put limitations here if there is truly no other way.

The difference between bi, tri and quadgrams is remarkable. When implementing text search in a relational system what you want is more specificity and less relationships simplifying potential join operations. It is for this reason that tri and quadgrams are preferred over bigrams. In the present context we're not dealing with join operations, but with search operations. It is for this application that we want a high volume of specific signals, thus a bloom filter of bigrams.

---

Assuming the use of an 8-bit bigram we can work out the parameters for a bloom filter.

---

Yet another exciting approach we can venture into is to figure out how to transform our distributed binary tree into some distributed octree. The practical result is that the tree requires less depth to search through the full tree. E.g. there is more localized knowledge contained in each leaf. If we go with an octree this means that:

- We can individually set 8 bits on the underlying leaves
- We can create a mutually exclusive match on 3 bits (e.g. `000`, `001`, `010`, `011`, `100`, `101`, `110`, `111`)

The first approach of overlapping bounding trees is impractical, thus we'd need to go for the mutually exclusive logical partitioning. As for the length of a potential bloom filter this means we can divide the length of the filter by 3 to get the depth required to fully search through the filter. A downside is that For a match on `001` we'd need to read through 4 descendants of the tree to end up on potential matches. Read amplification in the situation no match is found is worse though, since the absence of a match to the query does not mean the underlying nodes do not contain said element. It'd mean we need to read all 8 underlying nodes, as would have been the case anyways if we'd run a binary tree.

