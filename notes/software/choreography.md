---
title: Choreography
layout: default
---

# Choreography
In a choreographed system, software components themselves have the freedom and responsibility to integrate with the remainder of the system. A concrete example would be an event-driven system wherein each component may register to receive specific events, upon which it acts.

From a conceptual perspective, choreography can be thought about as a dance, where one has to keep track of one another to see what is going on and get cues as to the expected behaviour of themselves.

## Strenghts / weaknesses
The strenghts of choreographies can be found in the decoupled approach. Components may exist on their own, without detailed knowledge about the remainder of the system.

While this provides much flexibility as to the future development of the system, it also requires a bigger investment in infrastructure ahead of time. Whereas with [orchestration](/notes/software/orchestration) the infrastructure is partially contained in the business logic, such thing is not (necessarilly) the case with choreography.

A choreographed system can be thought about as a collection of different scripts, which have common triggers. This may be confusing to someone not familiar with the paradigm, and sometimes requires more explicit communication among parts of the system to ensure the correct behaviour is ran.