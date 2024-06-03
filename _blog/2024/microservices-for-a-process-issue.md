---
title: "'microservices' for a process problem"
slug: "microservices-for-a-process-issue"
toc: false
date: 2024-06-03
---

This document is not so much an opinion about microservices as much as it is a reflection of my own career development and my use/application of microservices. When I started as a developer about a decade ago microservices were just around the corner, and touted as the way to organize software due to all the various benefits it provided. The promise at the time had been that it simplified maintenance as different modules were isolated, and allowed you to focus only at one such module at a time.

Mind you I was a very junior developer back then, in charge of building a customer portal. The context involved an internet of things component, thus maintenance of that infrastructure was one of my responsibilities as well. As the junior I had been at the time writing stable software was an almost impossible task, let alone keeping all the moving bits and pieces running at the same time.

The IOT devices we were working with had a really basic TCP/IP stack, and were unable to deal with outages. Key for me therefore was to keep the infrastructure as stable as possible. Any failure would result in unrecoverable data loss.

And so with microservices being the fancy new way to structure software I decided to split out the TCP server in its own independent component. No matter what else would break, the TCP server would keep running and being able to collect data.

At the time there was not really a process. With myself ironically being the most senior around working on that project I had to figure things out by myself. There was no (slightly) formalized software development process. There were no automated tests to validate things were working correctly. There was no deployment process other than copy-pasting the locally compiled executables onto the server. Needless to say things broke, quite often.

As a further option to limit the spread of failures I continued splitting more services into modules theoretically being able to run independently. Sure enough all of them used the same database, but the database was rarely the single point of failure. Sure enough there would be deadlocks, but those were relatively easily resolved. And so there came another service, and another one, and another one.

From there onwards it did not take long to figure out the drawbacks of this microservice approach. While they provided containment of fatal errors, they did not help me architecturally at all. In fact the development process itself became slower and slower as more cross-cutting concerns were introduced. Changes to their APIs required modifying multiple services at the same time, causing tricky deployments in return. A service was not contained enough to be able to continue running in the absence of other services. If one service was down, multiple other services would fail or run in degraded modes.

But initially I started using this microservice (or were those macroservices?) for one reason; they provided a containment boundary for fatal errors. That's it. That's the reason.

Most of the issues we ran into afterwards could have been solved by properly architecting the application in the first place, but if that would have happened, we wouldn't have needed microservices anyways. It was not even a way to deal with the sociological structure of the organization, no, it was purely for technical reasons.

## In retrospect
Now in retrospect, about a decade later, I would have architected that whole application in a completely different manner. While the high-level structure of the application would still be the same, the way that we'd write software would have been fundamentally different, starting with the deployment process. Being able to do many small incremental changes is a game changer. The time between deployments was weeks at best. The downtime during a deployment would have been acceptable, so there wasn't even a need to go full blue/green.

> _I forgot that when I started out there we were even using VCS. Halfway about my time in there I had to put up a fight to get to start using Git. I feel old now._

From there onwards I'd write tons of automated tests. These would have been able to catch errors before being shipped to production. This would have gotten rid of our incentive to build microservices in the first place.

Beyond the process, further changes would have been more or less cosmological in nature. Whether we would have gone with microservices or with a monolithic deployment would not have mattered all that much, and could relatively easily be refactored if needed.

