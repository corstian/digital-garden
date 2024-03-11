---
title: "Orchestration"
layout: default
date: 30-11-2023
---

# Orchestration
Orchestration ([Wikipedia](https://en.wikipedia.org/wiki/Orchestration_(computing))) is a design approach whereby one component dictates the work other components should do.

On a conceptual level it may be helpful to think about a conductor leading an orchestra. The conductor has an overview over what is happening, and sends signals to coordinate everyone involved.

## Strengts / weaknesses
The strength of orchestrating business operations is that there is a higher level overview over what is happening. Operations smaller in scope are triggered from a business process governing the overarching operation. This might make it easier to understand what is going on.

This idea pushed to extreme forms allows components to trigger highly-dynamic operations across the system based on what is going on. In such situation each component would be able to hand off the operation to another part of the system which in turn should decide what happens next as well. The downside of this approach is that it becomes rather complicated to figure out what the system is doing, as it is quite likely the potential state space explodes.

Regardless of the extent to which these ideas are applied, a major downside (depending on perspective) are the tight coupling between components in the system. A single component - by design - must know about the specifics of their operation. It is not possible just to focus on a single task and let the remainder of the system figure out what is going on.