---
title: "Scalable event stores"
slug: "scalable-event-stores"
date: 2024-04-23
toc: false
---

Due to limitations I ran into using PostgreSQL as an event store (mostly related around cost/performance ratio) I started thinking about alternative ways to construct event-stores sidestepping the limitations I ran into. These limitations primarily revolve around elastic scalability and IO throughput.

The proposed idea is to construct an event store which is masivelly scalable on demand, and can scale back to zero if it needs to. In this design throughput is valued over latency. Additionally the design is constrained to that of an event store, and as such no general-purpose relational model will be developed either.

## High level overview
To achieve elastic scalability, compute and storage resources are decoupled from one another. While compute may be scaled to zero, a certain amount of storage capacity is always necessary to persist information.

To persist information we'll be using general purpose object storage such as Azure Blob Storage or Amazon's S3. Azure's performance and scalability targets for blob storage dictate read performance at 120 Gbps and write performance half that. The aim is for this system to be able to max out this allocated throughput through running an event store.

On the compute side of things we'll depend on an elastically scalable actor system for computational flexibility.

## Data storage
To facilitate querying the stored events, these will be encoded in a KD-tree. Computation and storage will be coupled by giving each actor instance access to a chunk of data representing a portion of this tree.

To facilitate scaling it is important that each chunk of data has partial visibility into the data contained in the remainder of the tree. Details on the specific details of the storage format can be found here: [MIDAS](/notes/papers/index-based-query-processing-on-distributed-multidimensional-data.md).

It should be acknowledged that while the data structure has beneficial scalability characteristics, it does not allow one to add additional split dimensions after the tree already exists, without touching every leaf in the tree. For this reason we should consider the data structure and index fields to be immutable after creation of the store.

We want to be able to query events based on the following fields:
- Event ID
- Stream ID
- Timestamp
- Stream type
- Event type

Evidently this will not allow querying based on the specific fields the event contains. This is a tradeoff I'm willing to make, which can be worked around by running projections on all events, rolling these up in a way which allows more straightforward access to this information.

