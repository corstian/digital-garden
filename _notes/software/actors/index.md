---
title: "Notes on actor systems"
layout: default
date: 04-02-2024
---

# Notes on actor systems
The ["actor model"](https://en.wikipedia.org/wiki/Actor_model) is an approach of organizing software in small cut up pieces. The smallest unit of work is the actor itself, which in functionality are limited to:
- Run computations
- Store information locally
- Communicate

This organization allows one to create larger systems, comprised of a large number of actor types and instances. This abstraction allows one to run such a system on a cluster of machines. This way the actor model is primarilly an abstraction hiding the infrastructural concerns of distributed software systems. For a more depth introduction see ["what is an actor system?"](/notes/software/actors/what-is-an-actor-system)

## Limitations
While it is possible to run a large variety of workloads on top of actor systems, the prime complexity of running an actor system revolves around architecting the workload to fit onto this model. See ["architectures of actor systems"](/notes/software/actors/architectures-of-actor-systems) for more context.

For highly specific and computationally heavy algorithms it might even be better to architect a custom approach, but these are supercomputer-adjadecent areas. In this area topics such as [remote direct memory access (RDMA)](https://en.wikipedia.org/wiki/Remote_direct_memory_access) become relevant. This however is irrelevant for most line-of-business applications, which are better served through writing against the actor model abstraction.

## Frameworks
There are a wide variety of tools helping one implement an actor system. These tools generally take on responsibilities such as load shedding, balancing cluster activity over nodes, locational transparency and more. While building a custom framework is an interesting learning experience, I would strongly discourage doing so for a production system due to the intrinsic complexity of abstracting distributed infrastructure.

Two such frameworks for .NET are:
- [Orleans](https://learn.microsoft.com/en-us/dotnet/orleans/)
- [Akka.net](https://getakka.net/)

## Random topics
- [Databases and actor systems](/notes/software/actors/databases-and-actor-systems)
- [Running a domain model as an actor system](/notes/software/actors/running-a-domain-model-as-an-actor-system)
- [The poor man's serverless architecture](/notes/software/actors/the-poor-mans-serverless-architecture)