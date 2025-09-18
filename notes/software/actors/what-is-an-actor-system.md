---
title: "What is an actor system?"
layout: default
toc: true
date: 29-11-2024
---

The notion of an actor model of computation ([Wikipedia](https://en.wikipedia.org/wiki/Actor_model)) is an abstraction over computational workloads with certain scalable benefits over more traditional, organic organisation of software.

The gist of this model is that one can choose to make software natively scalable among a cluster of machines. This at a slight cost to the flexibility with which one can organize the code. The model describes the constraints an actor must adhere to in order to be able to compose them into a scalable system:

- Persistence: _the actor is the sole component allowed to access their own storage space_
- Computation: _the actor may run code independent from the rest of the system_
- Communication: _the actor may communicate with the remainder of the system_

These constraints require us to think about how a system made up of these independent actors behaves. While the benefit is native scalability, it comes at the expense of network communication. After all, an actor may exist on the same node, or elsewhere on te network, but the calling actor will never know. Therefore an actor system can never be completely sure their dependency is available somewhere on the system. It pulls you straight into the fun world that is distributed systems. You cannot be sure of anything, and failure is always just around the corner.

There is a brilliant conversation among Carl Hewitt, Clemens Szyperski and Erik Meijer on this model, which so far I have found to be one of the clearest explanations on what the actor model actually is.

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/7erJ1DV_Tlo?si=o5HSWIN_4E77l0iQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Data Locality
One of the brilliant things about actors is that they themselves are responsible for the data they store. For people used to dealing with massive databases this locality can feel both chaotic and relieving at the same time. Making the actor responsible for the way it interacts with the data contained therein allows more granular control over massive data sets.

This leads us to more exotic system architectures, such as Actor Oriented DataBases or AODBs in short ([presentation](https://www.microsoft.com/en-us/research/uploads/prod/2018/04/ICDE2018-Keynote.pdf), [paper](https://www.researchgate.net/publication/311081478_Indexing_in_an_Actor-Oriented_Database)).

## Actor Systems and Domain Driven Design
Much of my own work had been focussed around integrating the notion of an actor system with the ideas as expressed in the Domain Driven Design methodology. The result of this work is the conclusion that the DDD and Actor models may enrich one another. Especially so as both are responsible for a completely different aspects of software. Whereas DDD is about the maintainability and legibility of code, the actor model is mostly an internal infrastructural concern.