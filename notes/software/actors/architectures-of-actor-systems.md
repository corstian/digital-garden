---
title: "Architectures of Actor Systems"
layout: default
toc: true
date: 30-11-2023
---

# Architectures of actor systems
Even though the principal unit of construction of an actor system is the actor itself, even then there are a wide variety of approaches one can follow to construct the actor system itself.

When it comes to the organisation of a distributed system there are two primary schools about how to structure interaction among one another:

- [Orchestration](/notes/software/orchestration)
- [Choreography](/notes/software/choreography)

The main difference is the coordination of behaviour. Both approaches have their strengths and weaknesses, and both can be implemented in an actor system.

## Orchestration in an actor system
For orchestration to work in an actor system, the initial actor called must have a bit of knowledge about the remainder of the actor sytem. If it wants to defer behaviour to other actors, it should explicitly call these actors.

In an orchestrated system actors are generally directly calling one another. This provides the additional benefit of having object capabilities built right in. Following this paradigm one should consider that whenever an actor has the address of another actor, said actor is allowed to call the referenced actor. As long as one can enforce said assumption this has some highly beneficial properties for the security of the system.

## Choreography in an actor system
In a choreographed system, actors are generally instantiated on-demand. The "demand" in this case may vary wildly, based on the specifics of the underlying infrastructre. One may think about it as being a HTTP-request, a message delivery, or any other trigger which would make sense given the use-case.

The component handling the operation may then create other triggers, which can be picked up by other actors.

Note that when it comes to an actor system, a choreographed system does not necesarilly directly involve external actor calls, as these may be abstracted away through infrastructure. This does not necesarilly mean reduced scalability, as the infrastructure itself may be built on top of actors as well, though there certainly is a slight paradigm shift in the way one invokes these actors.

## Challenges using actor systems
The two aforementioned mental models about communication structures in distributed systems are not mutually exclusive either. Some parts of the system may follow an orchestration-like pattern, while other parts opt for a choreography-like model. 

### Networking
A prime challenge in the use of actor systems is network connectivity and communication. Generally (configuration changes aside), a given actor may exist anywhere on the cluster. As such the round trip time (RTT) for communication with another actor may be anywhere between 0ms and 300ms (if the actor is in a data center on the other side of the world). While it is still possible to create performant systems using actors, it is absolutely key to reduce the amount of blocking network IO. This translates to a design constraint when scoping out the structure of the actor system.
