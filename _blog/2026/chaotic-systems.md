## Outline
- Distributed transactions: yay or nay
- Distributed messaging
- Distributed coordination

---

Atomic transactions are nearly necessary to ensure predictable state of information systems. A given operation can then either have failed or have ran to completion. There are no in-betweens. There are no edge cases to consider.

In simple systems the responsibility for transaction management is generally offloaded onto the persistence engine -- be it a database, file storage or whatever else. This way the only thing an application has to do is to define where the operation starts and where it ends.

Things become more difficult when using multiple data-storage engines. At this point one can no longer rely on a single data store, but instead must coordinate across multiple components. Even this with the necessary controls in place is rather straightforward -- as long as one is running from a single process.

Where transactions become troublesome is within distributed systems. In case the distributed system still access a centralized data store things remain manageable. When the distributed system however uses multiple different data stores we'll have to move responsibility for transaction management from the data store to the application. Even in systems like these there are gradations as to how complex it is to coordinate work. The coordination of work in a monolithic distributed system for example is easier to achieve than the coordination of work across an incoherent collection of services.

## Dynamics of a transaction
To understand the problem of distributed transactions we'll try to dissect a transaction into distinct phases. While there are various transaction mechanism (read: [Paxos](https://en.wikipedia.org/wiki/Paxos_(computer_science)), [2PC](https://en.wikipedia.org/wiki/Two-phase_commit_protocol), [3PC](https://en.wikipedia.org/wiki/Three-phase_commit_protocol), [Raft](https://en.wikipedia.org/wiki/Raft_(algorithm)), and more), the overall dynamics remain the same.

In general a transaction consists of two parts:

1. Collect what needs to be done
2. Doing the thing

This is the regardless of whether you're a database or an application. The thing where (distributed) commit protocols differ is about how to achieve consensus on what operations needs to be done. This is something I will not write about further in this post.

What makes it so convenient for a database to handle transactions is that as far as the database is concerned it only considers current state and future state. It is unburdened by how that state came to be -- al it knows its state needs to change, and it needs to change all that needs to change or nothing at all.

Bringing transaction management to applicatoins therefore becomes a different kind of beast for not only it has to deal with managing current and future state, but also has to deal with how this state came to be. And let this be the difficult part of distributed state management.

Generally when applications are built in more or less object oriented fashion the logic determining state changes is imperative. It gets a copy of the previous state, checks if a change can be made, and then makes those changes. The coupling between a pure evaluation (whether the state change can be made) and side effects make it difficult to have these odd bits and pieces of code run in a coherent fashion. Ideally if we want such code to participate in a transaction we'll have to decouple the pure evaluation from the side effects.

## Effect systems
Reasonably enough I'm not the first to run into this problem. One solution put forward to this problem are [effect systems](https://en.wikipedia.org/wiki/Effect_system). These systems - plainly put - allow one to write pure imperative code. The code still describes the side effects they are about to apply, but rather than immediately executing them, they are collected for them to be evaluated only after the pure part had finished.

While effects allow deferring responsibility for some operation to an external component (e.g. check the [Eff](https://github.com/nessos/Eff) project for a C# implementation), it wont save us from architectural flaws in the face of a distributed system. Something which is pefectly fine in a non-distributed monolith, can have significant performance implications in a distributed environment. Each coordinative action incurs overhead, and as such we'd want to keep an operation local as long as reasonably possible, and effects can help us with that.

Considering locality of operations should have tangible impact on the code one writes. A practical example is a database operation. No longer would we retrieve a thing from the database followed by a mutation, but instead describe the change we want to see and ship it off. We'd no longer be interested in the concrete output of things, but rather about issuing instructions to the system for further operations to be executed. This way we're shifting side-effects further towards the end of the execution chain -- or in this case perhaps the transaction. We can make the system responsible for figuring out how to apply these side-effects and worry no more ourselves.

It is somewhat remarkable that this shares similarities with event-driven architectures. Both systems share messages indicating state changes are about (or have) happened. Both separate contents of the operation from the operation itself through handlers. This functions as inspiration for the design of some system.


## About on-demand evaluation
One major risk running distributed transactions is lock contention. The number of concurrent operations possible is limited by the time a lock is held on some critical object. As such one major goal of an application-driven transaction manager is to limit the time needed to lock objects.
