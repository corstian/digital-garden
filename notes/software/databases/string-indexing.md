---
title: "String indexing"
layout: default
date: 28-01-2024
---

# String indexing
String indices are one of the more complicated aspects of database systems. Where querying number based information is a relatively straightforward process, even at scale, this is different for textual information.

At this moment about the best we can do is the use of an inverted index. These store pieces of text, and a reference to the actual location containing the document. The way this is done is implementation specific, although trigram based indices are pretty common.
