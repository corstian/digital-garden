---
title: "Sagas"
layout: default
toc: true
---

# Notes on the saga pattern

The saga design pattern is one which is often misunderstood. One cause for this are the multiple different interpretations based on the context in which the saga is implemented. The meaning of a saga as they are used in database systems oftentimes differs from the meaning of a saga as used in a distributed system.

Oftentimes both the saga pattern and the process manager are confused for one another. While both respond to incoming events, the difference exists around the management of local state. The saga itself does not hold any state, and can respond based on the provided event. The process manager in this regard is different as it can hold state. It is the accumulation of local state which may determine how it responds to an incoming event. Process managers are easily implemented using aggregates from the DDD methodology.

See [this StackOverflow answer](https://stackoverflow.com/a/15764667/1720761) for further context as well.


## Sagas in event driven systems
When a saga is used within an event driven system it can be used to model long-running processes. The saga can be used to respond to certain events, and continue with furhter operations. If the operations themselves can be represented as a single atomic operation, the saga can be thought about as the boundaries between distinct temporal steps as well, thus simplifying ones ability to reason about complex and long running operations as well.

In an event driven system there are two primary use-cases for the saga pattern:
- To run compensatory actions to deal with failure
- To retroactively respond to issued events

Depending on the systems architecture and overarching principles there may be subtle details to consider during the implementation of sagas. One especially important aspect is the evaluation dynamic in the system, whether this is exactly once, at most once or at least once.

At-least-once evaluation is easiest and safest to implement as it doesn't place stringent requirements on the underlying infrastructure. To compensate for this the code itself must be idempotent, thus being able to be evaluated without further side effects.



## Sagas in their broader context
[Beyond the saga pattern](https://speakerdeck.com/ufried/beyond-the-saga-pattern)