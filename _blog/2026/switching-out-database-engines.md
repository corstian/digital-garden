---
title: "Sqlite event stores"
---

About a decade ago conventional wisdom regarding database engines, ORMs and data models was that once an application was functioning you'd never swap out the database engine ever again. Too much work for too little impact. In the meantime I have been working on projects where over the course of its lifetime we switched databases three times. Something which - due to the way the solution had been architected - we could do rather quickly. High level technical capabilities such as event-sourcing and CQRS were useful in the way that these made exactly clear how big the surface area with the database systems had been.

Over time I started to appreciate these techniques - event sourcing and CQRS - as basic building blocks for applications. It's the paradigm underpinning event-sourcing providing the append and query dynamic as contrasted to the more often seen create-read-update-delete operations. These append-query operations can then be wired up to projections providing CQRS.

While this architecture started out in an elastically-scalable distributed application, the reality is that only a minority of software needs to be scalable at all. Most software should run perfectly fine on consumer grade hardware. And yet even for this type of software I want to stay in the append-query modus of development. While some may argue this architecture is definitely overkill for small consumer-oriented applications I argue it's too good of a fit for my development process to let go. Just allow me to append arbitrary events, to project these into a read model, and use this again in a user-facing UI. The mental model is simple enough to start out with, while the complexity ceiling is such that I'm unlikely to hit it even with a reasonably complex application.

That is to say while the mental model scales elegantly from a single machine to a cluster - for general software projects I do not want to have to run a cluster in order to get my application up and running. The cost is too high, both from a monetary point of view as well as a cognitive perspective. Ideally I want to run a single executable and have everything up and running within a single process.



--- 

This post is about using SQLite as event-store, and the integration of it with the Whaally.Domain framework.
