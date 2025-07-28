---
date: 2025-07-27
title: "Scalability concerns of actor systems"
---

Scalability concerns of actor systems
=====================================

Actor systems provide brilliant scalability characteristics for software systems. The abstraction of a single actors allows one to deploy software which is indifferent to a particular machine it is running on. Consequently one can dynamically move the cluster of individual actors over a varying number of physical machines.

## The big actor monolith
One of my favourite approaches to building an actor system is the generalized monolith. This approach consists of a single monolith which can be horizontally scaled by simply starting multiple instances of the same program alongside one another. This works brilliantly well when using a fairly simple actor system with similarly sized actors, but starts to grow increasingly complicated as soon as multiple types of workloads are shared together.

> This is an issue not in the least place because actor systems are not inherently (as in implicitly and by design) testable. One will need to pour some conscious thought in this in order to maintain testable subsystems.

An alternative to this approach is to offload certain tasks to external services through a queue based system.

## Downstream dependencies
While the actor system itself may be dynamically and nearly instanteneously scalable, downstream dependencies of such a system may not. Often times the backing database does not have the same scalability characteristics as the actor system, still requiring on to be relatively mindful of the way such a system scales.

It is due to the dynamic scalability of actor systems that special care should be taken not to overload downstream dependencies. These are most notably persistence related and external integrations. If one is lucky and the throughput to these dependencies is not properly handled the relevant actor will crash, back off and try again after some time. In a bad case the system will come to a halt as it is interacting with the external service, timing out, and trying again, succumbing to a denial of service on an external dependency created by itself.

It is not to say an actor system is worthless whenever the downstream dependencies do not scale equally as well. Quite the opposite as an actor system can still act as a cache to a database, removing a significant amount of load for read operations for the data store. Care should be taken however to decouple external services.

### Decoupling external services
When running an actor system one should generally assume any other systems you're interacting with have a lower capacity than your system. For this reason:

- The system should function without said external system being online
- Interactions with external system should have additional resillience built in:
    - Use aggressive timeouts wherever possible
    - A retry containing an exponential back off (and some randomness built in to prevent request-hammer)
    - A queue with operations to external system

While this is how one should interact with external system, this is not the case when interacting with your own actor-based system. Operating under the premise that the system dynamically scales under load you can generally just push load it until its breaking point (which is likely the database).

## Load shedding
If the actor system in use has many different types of actors one viable strategy might be load shedding. Whenever a specific resource is resource-constrained, other non-critical operations may be deferred for the time being. This works brilliantly well for background jobs.

## Actor resource use and inertia
The scalability characteristics between actor systems even differs drastically based on the size (resource consumpion) of the actors, and the interactivity between the actors. The smaller and short-lived these units are, the faster an actor system can be scaled. The opposite is true as well. The larger these are, and most notably the longer they live and remain active, the longer it takes for a system to scale.

It should be noted that there is a significant difference between scaling up and down such a system. While scaling up can be done nearly instantaneous, scaling down might take a while as resources need to be freed up, workloads need to be shifted, and caches need to be invalidated.
