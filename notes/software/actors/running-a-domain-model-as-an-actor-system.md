---
title: "Running a domain model as an actor system"
layout: default
date: 27-01-2024
---

# Running a domain model as an actor system
Just having a core domain model does not mean this domain model is able to properly scale across a cluster of machines. On the other hand, it is not impossible to get a core domain to scale across the cluster either. The trick to be able to do so is to get the correct abstractions in place.

As it turns out there is some common ground between the DDD methodology and the actor model. This common ground is the isolation of information. Within a domain model information is contained in the aggregate. In the actor model this is the actor. Therefore, if an aggregate instance is encapsulated within an actor, at least all active aggregate instances can be distributed over a cluster of machines.

However, we're not done yet. After the aggregate had been encapsulated all kinds of different questions arise:
- "How are we going to invoke domain behaviour?"
- "How do we get services to be able to call aggregates?"
- "Is there any overlap between the domain model and the actor system?"
- "Can we decouple the actor system from the domain model?"

Most of these are problems I have already solved before in the [`Whaally.Domain` library](https://github.com/whaally/domain).